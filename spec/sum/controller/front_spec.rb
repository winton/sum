require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe 'Front Controller' do
  include Rack::Test::Methods
  
  def app
    Application
  end
  
  describe 'get /' do
    
    before(:each) do
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
  
  describe 'post /new' do
    describe 'valid' do
      
      before(:each) do
        post '/new',
          "user[email]" => "test@test.com",
          "user[bills]" => "1000.02",
          "user[income]" => "2500.54",
          "user[savings]" => "500.02",
          "user[timezone_offset]" => "-25200"
      end
    
      it "should respond ok" do
        last_response.should be_ok
      end
    
      it "should succeed" do
        last_response.body.include?("Success!").should == true
      end
    
      it "should not contain a form" do
        last_response.body.include?("<form").should == false
      end
    end
    
    describe 'invalid' do
      
      before(:each) do
        post '/new',
          "user[email]" => "",
          "user[bills]" => "",
          "user[income]" => "",
          "user[savings]" => "",
          "user[timezone_offset]" => ""
      end
    
      it "should respond ok" do
        last_response.should be_ok
      end
    
      it "should not succeed" do
        last_response.body.include?("Success!").should == false
      end
    
      it "should contain a form" do
        last_response.body.include?("<form").should == true
      end
    end
  end
end
