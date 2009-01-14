require 'ruby-debug'

module Patch
  module Acts
    module Recoverable
      
      def acts_as_recoverable
        return if self.included_modules.include?(InstanceMethods)
        
        include InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval do
            before_destroy :create_recoverable_object_for
            extend Patch::Acts::Recoverable::SingletonMethods
          end
        end

        def create_recoverable_object_for(object = self, results = {})
          RecoverableObject.create(:object => object)
        end

        def destroy!
          def self.create_recoverable_object_for; end # is there a cleaner way to do this?
          destroy
        end
      end

      module SingletonMethods
        def find_and_recover(id)
          ro = RecoverableObject.find(:first, :conditions => ["recoverable_id = ? and recoverable_type = ?", id, self.to_s])
          if ro
            ro.recover! 
          else
            raise ActiveRecord::ActiveRecordError.new("Could not find recoverable with recoverable_id = #{id} and recoverable_type = #{self.to_s}")
          end
        end
      end

    end
  end
end

ActiveRecord::Base.send(:extend, Patch::Acts::Recoverable)