class Package < ActiveRecord::Base
  attr_accessible :file, :name, :file_cache, :user_id
  mount_uploader :file, FileUploader
  
  validates_presence_of :file, :name, :user_id
  
  before_save :update_file_attributes
  after_destroy :delete_file_from_disk

  has_and_belongs_to_many :servers
  belongs_to :user

  def full_path
    file.file.file
  end
  
  def file_name
    File.basename(full_path)
  end
  
  def creator
    user.name
  end
  
  def synced_servers
    servers
  end
  
  def unsynced_servers
    synced_ids = servers.map {|s| s.id}
    all_servers_ids = Server.all.map {|s| s.id}
    server_ids_to_search_for = all_servers_ids - synced_ids
    Server.active.where(:id => server_ids_to_search_for)
  end


  private
  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.size = file.file.size
    end
  end
  
  def delete_file_from_disk
    return unless file.present?
    remove_file!
  end

end
