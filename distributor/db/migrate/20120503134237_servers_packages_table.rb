class ServersPackagesTable < ActiveRecord::Migration
  def change
    create_table :packages_servers do |t|
      t.integer :package_id
      t.integer :server_id

      t.timestamps
    end
    add_index :packages_servers, [:server_id, :package_id]
  end
end
