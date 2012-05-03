class AddMetadataToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :size, :integer
    add_column :packages, :content_type, :string
  end
end