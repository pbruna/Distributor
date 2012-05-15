module JobsHelper
  
  def render_running
    return "" if @running.size < 1
    render :partial => "running"
  end
  
  def render_uncompleted
    return "" if @uncompleted.size < 1
    render :partial => "uncompleted"
  end
  
  def render_completed
    return if @recent.size < 1
    render :partial => "completed"
  end
  
  def format_error_message(message)
    return "No se registraron errores" if message.nil?
    messages = message.split(/\n/)
    content_tag :ul do
      messages.reduce('') {|c,msg| c << content_tag(:li, msg)}.html_safe
    end
  end
  
end
