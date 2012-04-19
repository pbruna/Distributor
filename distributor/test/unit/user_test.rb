require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "first user should be admin" do
    user = User.new(:email => "test2@example.com", :password => "123456", :password_confirmation => "123456")
    user.save
    assert(user.admin?, "No es admin")
  end
  
  test "there should be always one user" do
    user1 = User.new(:email => "test2@example.com", :password => "123456", :password_confirmation => "123456")
    user2 = User.new(:email => "test3@example.com", :password => "123456", :password_confirmation => "123456")
    user1.save
    user2.save
    users = User.all
    users.each do |user|
      user.destroy
    end
    assert_equal(1, User.count)
  end
  
  test "admin user cant not be deleted" do
    user = User.new(:email => "test2@example.com", :password => "123456", :password_confirmation => "123456", :admin => true)
    user2 = User.new(:email => "test3@example.com", :password => "123456", :password_confirmation => "123456")
    user2.save
    user.save
    user.destroy
    assert(User.find(user.id), "Failure message.")
  end
  
  test "always should be at least on admin" do
    user1 = User.new(:email => "test2@example.com", :password => "123456", :password_confirmation => "123456")
    user2 = User.new(:email => "test3@example.com", :password => "123456", :password_confirmation => "123456")
    user1.save
    user2.save
    user1.admin = false
    user1.save
    assert(User.count(:conditions => "admin = true") >= 1, "Failure message.")
  end
  
  test "name should return de first and last name" do
    user1 = User.new(:email => "test2@example.com", 
                      :password => "123456", :password_confirmation => "123456",
                      :first_name => "patricio", :last_name => "bruna")
    assert_equal("patricio bruna", user1.name)
  end
  
end
