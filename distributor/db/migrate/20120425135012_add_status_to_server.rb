class AddStatusToServer < ActiveRecord::Migration
  def change
    add_column :servers, :active, :boolean, :default => false
  end
end