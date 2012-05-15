class Job < ActiveRecord::Base
  attr_accessible :completed, :finish_time, :package_id, :process_id, :server_id, :start_time, :user_id
  belongs_to :server
  belongs_to :package
  belongs_to :user
  
  after_update :mark_package_as_synced
  
  def running?
    finish_time.nil?
  end

  def server_name
    server.name
  end
  
  def file_name
    package.file_name
  end
  
  def file_url
    package.file_url
  end
  
  def user_name
    return "" if user.nil?
    user.name
  end
  
  def package_name
    package.file_name
  end
  
  def duration
    return if finish_time.nil?
    finish_time.to_time - start_time.to_time
  end
  
  scope :running, where(:finish_time => nil)
  scope :recent, where(:completed => true).order("id desc").limit(10)
  scope :uncompleted, where(Job.arel_table[:finish_time].not_eq(nil), :completed => false)
  
  private
  def mark_package_as_synced
    return unless self.completed?
    package = Package.find(self.package_id)
    server = Server.find(self.server_id)
    package.servers << server
  end
  
end
