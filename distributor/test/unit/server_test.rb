require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  
  test "no save if ip_address is not valid" do
    server = Server.new(:name => "servidor", :creator => "patricio", :ip_address => "192idaoaod")
    server.save
    assert(server.errors.messages.has_key?(:ip_address), "Se guardo con IP no valida")
  end
  
end
