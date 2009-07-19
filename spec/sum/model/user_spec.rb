require 'erb'
require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe User do
  describe "creation" do
  
    before(:all) do
      @user = create_valid_user
    end
  
    it "should populate record attributes properly" do
      @user.email.should == "cucumber@sumapp.com"
      @user.recent_transactions.should == nil
      @user.savings_goal.should == 500.02
      @user.spending_goal.should == 1000.50
      @user.spent_this_month.should == 0.00
      @user.temporary_spending_cut.should == 0.00
      @user.timezone_offset.should == -25200
      @user.send_at.to_s.should == @user.send(:local_12am_to_server_time).to_s
      @user.reset_at.to_s.should == (@user.send_at + 1.month).to_s
    end
    
    it "should set send_at to today at 12am (local time)" do
      send_at = @user.send_at + @user.timezone_offset
      now = Time.now.utc + @user.timezone_offset
      send_at.day.should == now.day
      send_at.hour.should == 0
      send_at.min.should == 0
    end
    
    it "should reset balances one month from send_at" do
      @user.reset_at.should == @user.send_at + 1.month
    end
    
    it "should only save the last five transactions" do
      @user.recent_transactions = Array.new(6)
      @user.save
      @user.recent_transactions.length.should == 5
    end
    
    it "should make the savings goal equal to savings" do
      @user.savings_goal.should == @user.savings
    end
    
    it "should make the spending goal equal to income minus bills minus savings" do
      @user.spending_goal.should == @user.income - @user.bills - @user.savings
    end
  end
  
  describe "reset!" do
    
    before(:all) do
      @user = create_valid_user
      @user.spend!(1500.53)
      @old_reset_at = @user.reset_at
      @user.reset!
    end
    
    it "should set temporary_spending_cut to amount gone into debt" do
      @user.send(:two_decimals, @user.temporary_spending_cut).should == 0.01
    end
    
    it "should set spent_this_month to zero" do
      @user.send(:two_decimals, @user.temporary_spending_cut).should == 0.01
    end
    
    it "should add a month to reset_at" do
      @user.reset_at.should == @old_reset_at + 1.month
    end
  end
  
  describe "reset_spent_today!" do
    
    before(:all) do
      @user = create_valid_user
      @user.spend!(1.0)
      @user.reset_spent_today!
    end
    
    it "should set spent_today to zero" do
      @user.spent_today.should == 0
    end
  end
  
  describe "sent!" do
    
    before(:all) do
      @user = create_valid_user
      @old_send_at = @user.send_at
      @user.sent!
    end
    
    it "should set send_now to false" do
      @user.send_now.should == false
    end
    
    it "should add one day to send_at" do
      @user.send_at.should == @old_send_at + 1.day
    end
  end
  
  describe "spend!" do
    
    before(:all) do
      @user = create_valid_user
      @user.spend!(1.00)
    end
    
    it "should add the number to the user's recent transactions" do
      @user.recent_transactions.should == [ 1.0 ]
    end
    
    it "should add the number to the user's monthly spending total" do
      @user.spent_this_month.should == 1.00
    end
    
    it "should add the number to the user's daily spending total" do
      @user.spent_today.should == 1.00
    end
    
    it "should set send_now to true" do
      @user.send_now.should == true
    end
  end
  
  describe "errors" do
  
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
  
  describe "attribute protection" do
    
    before(:all) do
      @user = User.create(
        :email => "cucumber@sumapp.com",
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
