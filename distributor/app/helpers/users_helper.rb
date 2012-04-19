# encoding: utf-8

module UsersHelper

  def add_user_button
    if current_user.admin?
      button_link :text => "Agregar", :icon => "icon-user icon-white", :path => new_user_path, :class => "btn btn-primary"
    end
  end
  
  def edit_user_button(user)
    if current_user.admin? || current_user.id == user.id
      button_link(:text => "Editar", :path => edit_user_path(user), :class => "btn btn-mini")
    end
  end
  
  def delete_user_button(user)
    if current_user.admin?
      link_to 'Eliminar', user_path(user), :method => :delete, :confirm => 'Está seguro?', :class => 'btn btn-mini btn-danger'
    end
  end

end
