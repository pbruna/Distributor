class AddErrorMessageToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :error_message, :string
  end
end