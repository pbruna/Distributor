module JobsHelper
  
  def render_running
    return "" if @running.size < 1
    render :partial => "running"
  end
  
  def render_uncompleted
    return "" if @uncompleted.size < 1
    render :partial => "uncompleted"
  end
  
end
