require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe IncomingMail do
  describe "valid" do
    
    before(:all) do
      $db.migrate_reset
      @user = create_valid_user
      email = generate_email(
        :subject => "-11.11 -11 11.11",
        :body => "11 +11 +11.11"
      )
      @numbers = IncomingMail.receive(email)
    end
    
    it 'should process the correct numbers' do
      @numbers.should == [ -11.11, -11.0, -11.11, -11.0, 11.0, 11.11 ]
    end
  end
end
