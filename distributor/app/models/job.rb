class Job < ActiveRecord::Base
  attr_accessible :completed, :finish_time, :package_id, :process_id, :server_id, :start_time
  
  after_update :mark_package_as_synced
  
  
  private
  def mark_package_as_synced
    return unless self.completed?
    package = Package.find(self.package_id)
    server = Server.find(self.server_id)
    package.servers << server
  end
  
end
