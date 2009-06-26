require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe IncomingMail do
  describe "valid" do
    
    before(:all) do
      migrate_reset
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
    
    it "should add the numbers to the user's monthly spending total" do
      spent_this_month = @user.spent_this_month
      total = @numbers.inject(0) { |sum, item| sum + item }
      @user.reload
      @user.spent_this_month.should == spent_this_month + total
    end
    
    it "should add the numbers to the user's recent transactions" do
      @user.recent_transactions.should == @numbers.reverse
    end
  end
  
  describe "invalid no numbers" do
    
    before(:all) do
      email = generate_email(:body => "this is a test")
      @numbers = IncomingMail.receive(email)
    end
    
    it 'should fail' do
      @numbers.should == nil
    end
  end
  
  describe "invalid no user" do
    
    before(:all) do
      email = generate_email(:email => "not@user.com")
      @numbers = IncomingMail.receive(email)
    end
    
    it 'should fail' do
      @numbers.should == nil
    end
  end
end