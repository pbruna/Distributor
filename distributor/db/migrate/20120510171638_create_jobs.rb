class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :package_id, :null => false
      t.integer :server_id, :null => false
      t.integer :process_id, :null => false
      t.datetime :start_time, :null => false
      t.datetime :finish_time, :null => false
      t.boolean :completed, :default => false

      t.timestamps
    end
    
    add_index :jobs, :package_id
    add_index :jobs, :server_id
  end
end
