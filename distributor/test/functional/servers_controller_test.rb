require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @admin = User.new(:email => "admin@example.com", :password => "123456", :password_confirmation => "123456")
    @user = User.new(:email => "user@example.com", :password => "123456", :password_confirmation => "123456")
    @admin.save
    @user.save
  end

  def teardown
    @admin.destroy
    @user.destroy
  end

  test "should create and show server after create" do
    sign_in @admin
    assert_difference "Server.count", +1 do
      post :create, :server => {:ip_address => "192.168.0.1",
                                :name => "test.example.com",
                                :creator => "User Test"}
    end

    assert_redirected_to server_path(assigns(:server))
  end

end
