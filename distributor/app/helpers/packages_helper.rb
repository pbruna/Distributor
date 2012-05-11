# encoding: utf-8
module PackagesHelper
  
  def render_servers(file)
    if file.has_unsynced_servers?
      render :partial => "servers"
    else
      content_tag(:div, "Todos los servidores están sincronizados", :class => "alert alert-info")
    end
  end
  
end
