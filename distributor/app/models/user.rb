class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  before_save :set_as_admin_if_first_user
  before_destroy :no_destroy_if_last_user
  before_destroy :no_destroy_if_admin
  before_update :no_update_if_is_the_only_admin

  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  # attr_accessible :title, :body
  
  has_many :packages
  has_many :jobs

  def name
    "#{first_name} #{last_name}"
  end
  
  def self.are_any_admin?
    (User.count(:conditions => "admin = true") > 0)
  end

  private
    def set_as_admin_if_first_user
      return if User.count != 0
      self.admin = true
    end

    def no_destroy_if_last_user
      if User.count == 1
        errors.add :base, "No se puede eliminar porque siempre debe existir al menos un usuario"
        false
      end
    end

    def no_destroy_if_admin
      if admin?
        errors.add :base, "No se puede eliminar un usuario administrador"
        false
      end
    end

    def no_update_if_is_the_only_admin
      if only_admin? && changed_attributes.has_key?("admin")
        errors.add :base, "No se puede modificar porque es el unico usuario administrador"
        false
      end
    end

    def password_required?
      new_record?
    end

    def only_admin?
      return unless User.find(self.id).admin?
      !(User.count(:conditions => "admin = true") > 1)
    end

end
