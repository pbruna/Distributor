module Distributor
  class Syncer
    attr_accessor :package, :server, :sync_command
  
    def initialize(package, server)
      @package = package
      @server = server
      @sync_command = "rsync -az -e 'ssh -i #{Server::IDENTITY_FILE_PATH} -o ConnectTimeout=10' --partial"
    end
  
    def sync!
      return false unless server.active?
      system("#{sync_command} #{package.full_path} #{Server::CLIENT_USER}@#{server.ip_address}:#{Server::CLIENT_DIRECTORY}")
      return $? # Variable que tiene el resultado del comando anterior
    end
  
  end
end