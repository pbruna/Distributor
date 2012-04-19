class Server < ActiveRecord::Base
  attr_accessible :creator, :ip_address, :name
  
  validates_presence_of :name, :creator, :ip_address
  validates_uniqueness_of :ip_address, :message => "must be unique"
  validate :ip_address_must_be_valid
  
  private
  def ip_address_must_be_valid
    begin
      IPAddress.parse ip_address
    rescue ArgumentError => e
      errors.add(:ip_address, e.message)
    end
  end
  
end
