class CreateConfigurables < ActiveRecord::Migration[4.2]
  def self.up
    create_table :configurables do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
    
    add_index :configurables, :name
  end

  def self.down
    remove_index :configurables, :name
    drop_table :configurables
  end
end