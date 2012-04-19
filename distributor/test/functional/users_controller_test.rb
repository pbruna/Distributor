require 'test_helper'

class UsersControllerTest < ActionController::TestCase
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
  
  test "admin can add users" do
    sign_in @admin
    get :new
    assert_response :success
  end
  
  test "normal user can't add users" do
    sign_in @user
    get :new
    assert_redirected_to users_path()
  end
  
  test "normal user can't edit other users" do
    sign_in @user
    get :edit, {'id' => @admin.id }
    assert_redirected_to users_path()
  end
  
  test "admin can edit users" do
    sign_in @admin
    get :edit, {'id' => @user.id }
    assert_response :success
  end
  
  test "normal user can't delete users" do
    @test = User.new(:email => "test@example.com", :password => "123456", :password_confirmation => "123456")
    @test.save
    sign_in @user
    delete :destroy, :id => @test.id
    assert_redirected_to users_path()
  end
  
  test "user should edit him self" do
    sign_in @user
    get :edit, {'id' => @user.id}
    assert_response :success
  end
  
end
