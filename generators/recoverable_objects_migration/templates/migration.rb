class RecoverableObjectsMigration < ActiveRecord::Migration
  def self.up
    create_table :recoverable_objects do |t|
      t.column :recoverable_id, :integer, :null => false
      t.column :recoverable_type, :string, :limit => 255, :null => false 
      t.text :object_hash
      t.column :deleted_at, :timestamp
      t.timestamps
    end
  end
  
  def self.down
    drop_table :recoverable_objects
  end
end
