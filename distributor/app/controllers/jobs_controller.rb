class JobsController < ApplicationController
  
  def index
    @running = Job.running
    @uncompleted = Job.uncompleted
    @recent = Job.recent
  end
  
end
