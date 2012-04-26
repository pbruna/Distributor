class Server < ActiveRecord::Base
  
  SERVER_ADDRESS = APP_CONFIG['server_address']
  CLIENT_USER = APP_CONFIG['client_user']
  ADD_USER_COMMAND = "useradd -d /home/#{CLIENT_USER} -s /bin/bash -m #{CLIENT_USER}"
  MAKE_FILES_DIR_COMMAND = "su #{CLIENT_USER} -c 'mkdir /home/#{CLIENT_USER}/FILES'"
  MAKE_SSH_DIR_COMMAND = "su #{CLIENT_USER} -c 'mkdir /home/#{CLIENT_USER}/.ssh'"
  GET_SSH_KEY_COMMAND = "su #{CLIENT_USER} -c 'curl http://#{SERVER_ADDRESS}/#{APP_CONFIG['ssh_key_file']}.pub > /home/#{CLIENT_USER}/.ssh/authorized_keys'"
  
  attr_accessible :creator, :ip_address, :name, :active
  
  validates_presence_of :name, :creator, :ip_address
  validates_uniqueness_of :ip_address, :message => "must be unique"
  validate :ip_address_must_be_valid
  
  def activate!(user, password)
    return if active?
    result = nil
    Net::SSH::start(ip_address, user, {:password => password}) do |ssh|
      result = ssh_exec! ssh, "ls /"
    end
    result
  end
  
  private
  def ip_address_must_be_valid
    begin
      IPAddress.parse ip_address
    rescue ArgumentError => e
      errors.add(:ip_address, e.message)
    end
  end
  
  def ssh_exec!(ssh, command)
    stdout_data = ""
    stderr_data = ""
    exit_code = nil
    exit_signal = nil
    ssh.open_channel do |channel|
      channel.exec(command) do |ch, success|
        unless success
          abort "FAILED: couldn't execute command (ssh.channel.exec)"
        end
        channel.on_data do |ch,data|
          stdout_data+=data
        end

        channel.on_extended_data do |ch,type,data|
          stderr_data+=data
        end

        channel.on_request("exit-status") do |ch,data|
          exit_code = data.read_long
        end

        channel.on_request("exit-signal") do |ch, data|
          exit_signal = data.read_long
        end
      end
    end
    ssh.loop
    [stdout_data, stderr_data, exit_code, exit_signal]
  end
  
end
