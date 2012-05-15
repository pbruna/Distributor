class JobsController < ApplicationController
  
  def index
    @running = Job.running
    @uncompleted = Job.uncompleted.reverse
    @recent = Job.recent.reverse
  end
  
  def show
    @job = Job.find(params[:id])
  end
  
end
