class Server < ActiveRecord::Base

  SERVER_ADDRESS = APP_CONFIG['server_address']
  CLIENT_USER = APP_CONFIG['client_user']
  CLIENT_DIRECTORY = APP_CONFIG['client_directory']
  ADD_USER_COMMAND = "useradd -d /home/#{CLIENT_USER} -s /bin/bash -m #{CLIENT_USER}"
  DEL_USER_COMMAND = "userdel -r -f #{CLIENT_USER}"
  MAKE_FILES_DIR_COMMAND = "su #{CLIENT_USER} -c 'mkdir -p #{CLIENT_DIRECTORY}'"
  MAKE_SSH_DIR_COMMAND = "su #{CLIENT_USER} -c 'mkdir /home/#{CLIENT_USER}/.ssh'"
  GET_SSH_KEY_COMMAND = "su #{CLIENT_USER} -c 'curl http://#{SERVER_ADDRESS}/#{APP_CONFIG['ssh_key_file']}.pub > /home/#{CLIENT_USER}/.ssh/authorized_keys'"
  IDENTITY_FILE_PATH = "#{Rails.root}/#{APP_CONFIG['ssh_key_file_path']}/#{APP_CONFIG['ssh_key_file']}"
  SET_PERMISSIONS = "chmod 755 /home/distributor/.ssh/ && chmod 644 /home/distributor/.ssh/authorized_keys "

  attr_accessible :creator, :ip_address, :name, :active

  validates_presence_of :name, :ip_address
  validates_uniqueness_of :ip_address, :message => "must be unique"
  validate :ip_address_must_be_valid

  has_and_belongs_to_many :packages


  scope :active, where(:active => true)

  def synced_packages
    packages
  end

  def unsynced_packages
    synced_ids = packages.map {|p| p.id}
    all_packages_ids = Package.all.map {|p| p.id}
    package_ids_to_search_for = all_packages_ids - synced_ids
    Package.where(:id => package_ids_to_search_for)
  end
  
  def has_unsynced_packages?
    unsynced_packages.size > 0
  end


  # TODO: Ver que pasa si no hay conexión al sitio web
  # TODO: Refactor activate / deactivate methods
  def activate(user, password)
    return if active?
    activate_result = nil
    begin
      Net::SSH::start(ip_address, user, {:password => password, :timeout => 5}) do |ssh|
        activate_result = ssh_exec! ssh, "#{ADD_USER_COMMAND} && #{MAKE_FILES_DIR_COMMAND} && #{MAKE_SSH_DIR_COMMAND} && #{GET_SSH_KEY_COMMAND} && #{SET_PERMISSIONS}"
      end
    rescue Errno::ETIMEDOUT => e
      activate_result = {:error => true, :message => e.message}
    rescue Timeout::Error => e
      activate_result = {:error => true, :message => e.message}
    rescue Errno::EHOSTUNREACH => e
      activate_result = {:error => true, :message => e.message}
    rescue Errno::ECONNREFUSED => e
      activate_result = {:error => true, :message => e.message}
    rescue Net::SSH::AuthenticationFailed => e
      activate_result = {:error => true, :message => "Authentication failed"}
    end
    activate_result
  end

  def free_space
    0
  end

  def deactivate!(user, password)
    return unless active?
    activate_result = nil
    begin
      Net::SSH::start(ip_address, user, {:password => password, :timeout => 5}) do |ssh|
        activate_result = ssh_exec! ssh, DEL_USER_COMMAND
      end
    rescue Errno::ETIMEDOUT => e
      activate_result = {:error => true, :message => e.message}
    rescue Timeout::Error => e
      activate_result = {:error => true, :message => e.message}
    rescue Errno::EHOSTUNREACH => e
      activate_result = {:error => true, :message => e.message}
    rescue Errno::ECONNREFUSED => e
      activate_result = {:error => true, :message => e.message}
    rescue Net::SSH::AuthenticationFailed => e
      activate_result = {:error => true, :message => "Authentication failed"}
    end
    if activate_result[:error]
      activate_result
    else
      self.active = false
      self.save
    end
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
            exit_code = data.read_long > 0 ? true : false
          end

          channel.on_request("exit-signal") do |ch, data|
            exit_signal = data.read_long
          end
        end
      end
      ssh.loop
      {:stdout => stdout_data, :message => stderr_data,
       :error => exit_code, :signal => exit_signal}
    end

end
