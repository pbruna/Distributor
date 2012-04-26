module ServersHelper

  def activate_server_button(server)
    if server.active?
      content_tag(:h2, content_tag(:span, "Activado!", :class => "label label-success"))
    else
      link_to "#{content_tag(:li, '', :class => 'icon-off icon-white')} Activar".html_safe, "",
        :class => "btn btn-primary"
    end
  end

end
