class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name, :null => false
      t.string :ip_address, :null => false
      t.string :creator, :null => false

      t.timestamps
    end
    
    add_index :servers, :name, :unique => true
    add_index :servers, :ip_address, :unique => true
    
  end
end