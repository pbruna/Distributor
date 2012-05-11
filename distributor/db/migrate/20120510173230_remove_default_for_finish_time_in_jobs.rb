class RemoveDefaultForFinishTimeInJobs < ActiveRecord::Migration
  def up
    change_column :jobs, :finish_time, :datetime, :null => true
  end

  def down
    change_column :jobs, :finish_time, :datetime, :null => false
  end
end