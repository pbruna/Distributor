# encoding: utf-8
module ServersHelper

  def activate_server_button(server)
    if server.active?
      content_tag(:h2, content_tag(:span, "Activo", :class => "label label-success"))
    else
      link_to "#{content_tag(:li, '', :class => 'icon-off icon-white')} Activar".html_safe, edit_server_path(server, :activate => true),
        :class => "btn btn-primary"
    end
  end
  
  def render_files(server)
    if server.has_unsynced_packages?
      render :partial => "files"
    else
      content_tag(:div, "Todos los archivos están sincronizados", :class => "alert alert-info")
    end
  end

end
