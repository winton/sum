require File.dirname(__FILE__) + '/../../spec_helper'

describe User do
  describe "valid submission" do
  
    before(:each) do
      @user = User.create(
        :email => "test@test.com",
        :bills => "1000.02",
        :income => "2500.54",
        :savings => "500.02",
        :timezone_offset => "-25200"
      )
    end
  
    it "should populate record attributes properly" do
      @user.email.should == "test@test.com"
      @user.recent_transactions.should == nil
      @user.savings_goal.should == 500.02
      @user.spending_goal.should == 1000.50
      @user.spent_this_month.should == 0.00
      @user.temporary_spending_cut.should == 0.00
      @user.timezone_offset.should == -25200
      @user.reset_at.to_s.should == 1.month.from_now.utc.to_s
      @user.send_at.to_s.should == 1.day.from_now.utc.to_s
    end
  end
end
