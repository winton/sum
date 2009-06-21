require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Front Controller' do
  include Rack::Test::Methods
  
  def app
    Application
  end
  
  describe '/' do
    it "get responds ok" do
      get '/'
      last_response.should be_ok
    end
  end
end
