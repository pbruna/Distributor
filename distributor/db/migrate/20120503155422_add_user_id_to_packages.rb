class AddUserIdToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :user_id, :integer, :null => false
  end
end