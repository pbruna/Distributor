class JobMailer < ActionMailer::Base
  default from: "distributor@cverde.cl"
  
  def failed_job(job)
    @job = job
    @url = job_url(job)
    @user = job.user
    @package = job.package
    @server = job.server
    mail(:to => @user.email, :subject => "Fallo el trabajo de sincronizacion #{job.id}")
  end
  
end
