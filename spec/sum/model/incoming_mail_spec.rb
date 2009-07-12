require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe IncomingMail do
  describe "valid" do
    describe "numbers only" do
      
      before(:all) do
        migrate_reset
        @user = create_valid_user
        email = generate_email(
          :subject => "-11.11 -11 11.11",
          :body => "11 +11 +11.11"
        )
        @numbers = IncomingMail.receive(email)
        @total = @numbers.inject(0) { |sum, item| sum + item }
      end

      it 'should process the correct numbers' do
        @numbers.should == [ 11.11, 11.0, 11.11, 11.0, -11.0, -11.11 ]
      end
    end
    
    describe "non-number characters (reply email)" do

      before(:all) do
        migrate_reset
        @user = create_valid_user
        email = generate_email(
          :subject => "-11.11 -11",
          :body => "11a"
        )
        @numbers = IncomingMail.receive(email)
      end

      it 'should process the correct numbers' do
        @numbers.should == [ 11.11 ]
      end
    end
  end
  
  describe "invalid" do
    describe "no numbers" do
      
      before(:all) do
        email = generate_email(:body => "this is a test")
        @numbers = IncomingMail.receive(email)
      end
    
      it 'should fail' do
        @numbers.should == nil
      end
    end
    
    describe "no user" do
      
      before(:all) do
        email = generate_email(:email => "not@user.com")
        @numbers = IncomingMail.receive(email)
      end
      
      it 'should fail' do
        @numbers.should == nil
      end
    end
  end
end
