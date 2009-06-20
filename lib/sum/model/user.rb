class User < ActiveRecord::Base
  
  attr_accessible :email
  attr_accessible :bills
  attr_accessible :income
  attr_accessible :savings
  
  before_create :set_savings_goal
  before_create :set_spending_goal
  before_create :set_reset_at
  before_create :set_send_at
  
  validates_numericality_of :bills, :income, :savings
  validates_presence_of :email
  
  def bills
    read_attribute :bills
  end
  
  def bills=(amount)
    write_attribute :bills, to_number(amount)
  end
  
  def income=(amount)
    write_attribute :income, to_number(amount)
  end
  
  def income
    read_attribute :income
  end
  
  def savings=(amount)
    write_attribute :savings, to_number(amount)
  end
  
  def savings
    read_attribute :savings
  end
  
  private
  
  def set_savings_goal
    self.savings_goal = self.savings
  end
  
  def set_spending_goal
    self.spending_goal = self.income - self.bills - self.savings
  end
  
  def set_reset_at
    self.reset_at = 1.month.from_now
  end
  
  def set_send_at
    self.send_at = 1.day.from_now
  end
  
  def to_number(string)
    string.gsub(/[^\d\.]/, '').to_f
  end
end
