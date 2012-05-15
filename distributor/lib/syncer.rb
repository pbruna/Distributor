module Distributor
  class Syncer
    TIME_OUT = 30
    attr_accessor :package, :server, :sync_command, :job_id

    def initialize(package, server, user_id, job_id = nil)
      @package = package
      @server = server
      @user_id = user_id
      @job_id = job_id
      @sync_command = "rsync -az  --timeout=30 -e 'ssh -i #{Server::IDENTITY_FILE_PATH} -o ConnectTimeout=30' --partial"
    end

    def sync!
      return false unless server.active?
      start_time = Time.now
      pid, stdin, stdout, stderr = Open4.popen4("#{sync_command} #{package.full_path} #{Server::CLIENT_USER}@#{server.ip_address}:#{Server::CLIENT_DIRECTORY}")
      stdin.close
      out, err = [stdout, stderr].map {|p| begin p.read ensure p.close end}
      job = Job.find_or_initialize_by_id(@job_id)
      job.package_id = @package.id
      job.server_id = @server.id
      job.process_id = pid
      job.start_time = start_time
      job.user_id = @user_id
      Process.waitpid(pid)
      process_status = $? # Variable que tiene el resultado del comando anterior
      job.finish_time = Time.now
      job.completed = process_status.exitstatus > 0 ? false : true
      job.error_message = err
      job.save
    end

  end
end
