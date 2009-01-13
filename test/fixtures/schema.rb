begin
  ActiveRecord::Schema.define(:version => 1) do
  
    create_table :articles, :force => true do |t|
      t.string :name
      t.string :type
      t.timestamps
    end
  
    create_table :tags, :force => true do |t|
      t.string :name
      t.integer :article_id
      t.timestamps
    end
  
    create_table :authors, :force => true do |t|
      t.string :name
      t.references :article
      t.timestamps
    end
  
    create_table :comments, :force => true do |t|
      t.text :content
      t.references :article
      t.timestamps
    end
    
    create_table :ratings, :force => true do |t|
      t.integer :value
      t.references :comment
      t.timestamps
    end
  
    create_table :listings, :force => true do |t|
      t.string :name
      t.timestamps
    end
  
    create_table :locations, :force => true do |t|
      t.string :address
      t.timestamps
    end
  
    create_table :listings_locations, :force => true do |t|
      t.references :listing, :location
      t.timestamps
    end
    
    create_table :recoverable_objects do |t|
      t.column :recoverable_id, :integer, :null => false
      t.column :recoverable_type, :string, :limit => 255, :null => false 
      t.text :object_hash
      t.column :deleted_at, :timestamp
      t.timestamps
    end
    
  end
rescue => e 
  p e.message
end