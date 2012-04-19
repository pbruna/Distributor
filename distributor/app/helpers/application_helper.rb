# encoding: utf-8

module ApplicationHelper

  def add_resource_button(resource, icon)
    path = "new_#{resource}_path".downcase
    button_link :text => "Agregar", :icon => "#{icon} icon-white",
      :path => send(path), :class => "btn btn-primary"
  end

  def edit_resource_button(resource)
    path = "edit_#{params[:controller].singularize}_path"
    button_link(:text => "Editar", :path => send(path, resource), :class => "btn btn-mini")
  end

  def delete_resource_button(resource)
    path = "#{params[:controller].singularize}_path"
    link_to 'Eliminar', send(path, resource), :method => :delete, :confirm => 'Esta seguro?', :class => 'btn btn-mini btn-danger'
  end

  def menu_link(controller, title)
    link = "#{controller}_path".downcase
    ccs_class = params[:controller] == controller ? "active" : ""
    "<li class='#{ccs_class}'>#{link_to title, send(link) }</li>".html_safe
  end

  def button_link(opts={})
    o = {:text => "", :icon => "", :class => "btn", :path => ""}.merge(opts)
    button = "<i class='#{o[:icon]}'></i>"
    link_to "#{button} #{o[:text]}".html_safe, o[:path], :class => o[:class]
  end

end
