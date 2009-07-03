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
  
  describe "calculations" do
    
    before(:all) do
      @user = User.create(
        :email => "test@test.com",
        :bills => "3000",
        :income => "5000",
        :savings => "1200",
        :timezone_offset => "-25200"
      )
      @user.spent_this_month = 10.00
      @user.spent_today = 0.00
      @user.reset_at = DateTime.parse("2009-08-01 12:00:00").to_time
      @user.send_at = DateTime.parse("2009-08-01 12:00:00").to_time
      @user.save
    end
    
    it "should" do
      debug "beginning_of_month " + @user.beginning_of_month.to_s
      debug "days_in_month " + @user.days_in_month.to_s
      debug "days_left " + @user.days_left.to_s
      debug "days_passed " + @user.days_passed.to_s
      debug "should_have_spent " + @user.should_have_spent.to_s
      debug "spending_goal " + @user.spending_goal.to_s
      debug "spending_goal_today " + @user.spending_goal_today.to_s
      debug "spending_goal_today_savings " + @user.spending_goal_today_savings.to_s
      debug "spending_per_day " + @user.spending_per_day.to_s
      debug "spent_this_month " + @user.spent_this_month.to_s
      debug "surplus " + @user.surplus.to_s
      debug "surplus_for_period " + @user.surplus_for_period.to_s
      debug "total_left " + @user.total_left.to_s
      debug "reset_at " + @user.reset_at.to_s
      
      u = @user
      puts "<pre>" + ERB.new(File.read(File.expand_path("#{SPEC}/../lib/sum/view/email.erb"))).result(binding) + "</pre>"
    end
    
    def days(day)
      day == 1 ? "day" : "#{day} days"
    end
    
    def money(amount)
      "$#{sprintf("%.2f", amount)}"
    end
  end
end
