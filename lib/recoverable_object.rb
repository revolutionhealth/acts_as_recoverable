class RecoverableObject < ActiveRecord::Base
  serialize :object_hash
  
  def recover
    load_from_hash(object_hash)
  end

  def recover!
    result = recover
    result.save
    result.after_recover(self) if result.respond_to?(:after_recover)
    self.destroy
    result
  end
  
  def object=(object)
    self.object_hash = get_object_hash(object)    
    self.recoverable_id = object.id
    self.recoverable_type = object.class.name
    self.deleted_at = Time.now
  end
  
  private
  
  # Create a new object by object type and then set all of the attributes
  # via setter methods to avoid restrictions on mass assignment.
  def load_from_hash(hash)
    return nil unless hash
    result = hash[:type].constantize.new
    
    hash[:attributes].each do |key, value|
      result.send("#{key}=", value)
    end
    
    hash[:reflections].each do |name, values|
      if values
        if values.is_a?Array
          reflection_objects = values.map { |h| load_from_hash(h) } 
          result.send("#{name}=", reflection_objects)
        elsif values.is_a?Hash
          reflection_object = load_from_hash(values)
          result.send("#{name}=", reflection_object)
        end
      end
    end
    
    result
  end
  
  def get_object_hash(object)
    return nil unless object
    hash = { :type => object.class.name, :attributes => object.attributes, :reflections => {} }
    
    object.class.reflections.each do |name, reflection|
      if reflection.options[:dependent] == :destroy
        if reflection.macro == :has_many
          hash[:reflections][name] = []
          Array(object.send(name)).each do |child|
            hash[:reflections][name] << get_object_hash(child) unless child.nil?
          end
        elsif reflection.macro == :has_one or reflection.macro == :belongs_to
          value = object.send(name)
          hash[:reflections][name] = get_object_hash(value)
        end
      elsif reflection.macro == :has_and_belongs_to_many
        ids_name = "#{name.to_s.singularize}_ids"
        hash[:attributes][ids_name] = object.send(ids_name)
      end
    end    
    hash
  end
end