require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe 'Front Controller' do
  include Rack::Test::Methods
  
  def app
    Application
  end
  
  describe 'get /' do
    
    before(:all) do
      get '/'
    end
    
    it "should respond ok" do
      last_response.should be_ok
    end
    
    it "should contain instructions" do
      last_response.body.include?("class='number'").should == true
    end
    
    it "should contain a form" do
      last_response.body.include?("<form").should == true
    end
  end
end
