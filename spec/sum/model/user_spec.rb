require 'erb'
require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe User do
  describe "valid submission" do
  
    before(:all) do
      @user = create_valid_user
    end
  
    it "should populate record attributes properly" do
      @user.email.should == "test@test.com"
      @user.recent_transactions.should == nil
      @user.savings_goal.should == 500.02
      @user.spending_goal.should == 1000.50
      @user.spent_this_month.should == 0.00
      @user.temporary_spending_cut.should == 0.00
      @user.timezone_offset.should == -25200
      @user.send_at.to_s.should == @user.send(:local_12am_to_server_time).to_s
      @user.reset_at.to_s.should == (@user.send_at + 1.month).to_s
    end
    
    it "should make the spending goal equal to income minus bills minus savings" do
      @user.spending_goal.should == @user.income - @user.bills - @user.savings
    end
    
    it "should make the savings goal equal to savings" do
      @user.savings_goal.should == @user.savings
    end
    
    it "should set send_at to today at 5am (local time)" do
      send_at = @user.send_at + @user.timezone_offset
      now = Time.now.utc + @user.timezone_offset
      send_at.day.should == now.day
      send_at.hour.should == 0
      send_at.min.should == 0
    end
    
    it "should reset balances one month from next 5am" do
      @user.reset_at.should == @user.send_at + 1.month
    end
    
    it "should only save the last ten transactions" do
      @user.recent_transactions = Array.new(6)
      @user.save
      @user.recent_transactions.length.should == 5
    end
  end
  
  describe "invalid submission" do
  
    before(:all) do
      @user = User.create(
        :email => "",
        :bills => "",
        :income => "test",
        :savings => "0"
      )
    end
  
    it "should create errors on the proper attributes" do
      @user.errors.on(:email).should == "can't be blank"
      @user.errors.on(:bills).should == 'is not a number'
      @user.errors.on(:income).should == 'is not a number'
      @user.errors.on(:savings).nil?.should == true
      @user.email = 'test'
      @user.valid?
      @user.errors.on(:email).should == 'is invalid'
    end
  end
  
  describe "hacker submission" do
    
    before(:all) do
      @user = User.create(
        :email => "test@test.com",
        :bills => "1000.02",
        :income => "2500.54",
        :savings => "500.02",
        :timezone_offset => "-25200",
        :temporary_spending_cut => 5000,
        :send_at => Time.now.utc
      )
      @user.update_attributes(
        :temporary_spending_cut => 5000,
        :send_at => Time.now.utc
      )
    end
    
    it "shouldn't assign protected attributes" do
      @user.temporary_spending_cut.should == 0.00
      @user.send_at.to_s.should == @user.send(:local_12am_to_server_time).to_s
    end
  end
end
