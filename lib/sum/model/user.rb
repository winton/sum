class User < ActiveRecord::Base
  
  attr_accessible :email
  attr_accessible :bills
  attr_accessible :income
  attr_accessible :savings
  attr_accessible :timezone_offset
  
  before_create :set_timestamps
  
  before_save :set_savings_goal
  before_save :set_spending_goal
  
  serialize :recent_transactions
  
  validates_numericality_of :bills, :income, :savings
  validates_presence_of :email
  
  [ :bills, :income, :savings ].each do |attribute|
    define_method(attribute) do
      read_attribute attribute
    end
    define_method("#{attribute}=") do |amount|
      write_attribute attribute, to_number(amount)
    end
  end

  private
  
  def next_5am(time)
    time = to_local(time)
    time = DateTime.strptime(
      time.strftime("%m/%d/%Y 05:00 %p %Z"),
      "%m/%d/%Y %I:%M %p %Z"
    )
    time = time.to_time
    if to_local(Time.now) > time
      time + 1.day
    else
      time
    end
  end
  
  def set_savings_goal
    if self.savings
      self.savings_goal = self.savings
    end
  end
  
  def set_spending_goal
    if self.income && self.bills && self.savings
      self.spending_goal = self.income - self.bills - self.savings
    end
  end
  
  def set_timestamps
    self.send_at = next_5am(Time.now) - self.timezone_offset
    self.reset_at = self.send_at + 1.month
  end
  
  def to_local(time)
    return time unless self.timezone_offset
    time.utc + self.timezone_offset
  end
  
  def to_number(string)
    string = string.gsub(/[^\d\.]/, '')
    string.blank? ? string : string.to_f
  end
end
