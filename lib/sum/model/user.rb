class User < ActiveRecord::Base
  
  attr_accessible :email
  attr_accessible :bills
  attr_accessible :income
  attr_accessible :savings
  attr_accessible :timezone_offset
  
  before_create :before_create_timestamps
  
  before_save :before_save_recent_transactions
  before_save :before_save_savings_goal
  before_save :before_save_spending_goal
  
  serialize :recent_transactions
  
  validates_format_of(
    :email,
    :with => /^[_a-z0-9\+\.\-]+\@[_a-z0-9\-]+\.[_a-z0-9\.\-]+$/i,
    :unless => lambda { |r| r.email.blank? }
  )
  validates_numericality_of(
    :bills,
    :income,
    :savings,
    :unless => lambda { |r| r.bills.nil? && r.income.nil? && r.savings.nil? }
  )
  validates_presence_of :email
  
  [ :bills, :income, :savings ].each do |attribute|
    define_method(attribute) do
      read_attribute attribute
    end
    define_method("#{attribute}=") do |amount|
      write_attribute attribute, to_number(amount)
    end
  end
  
  # Beginning of fiscal month
  def beginning_of_month
    self.reset_at - 1.month
  end
  
  # Days in this fiscal month
  def days_in_month
    self.reset_at.to_date - self.beginning_of_month.to_date
  end
  
  # Days left in this fiscal month
  def days_left
    self.days_left_including_today - 1
  end
  
  # Days left in this fiscal month in decimal form
  def days_left_precise
    puts Time.now.utc.inspect
    (self.reset_at - Time.now.utc) / (24*60*60)
  end
  
  # Days left in this fiscal month, including today
  def days_left_including_today
    self.reset_at.to_date - Time.now.utc.to_date
  end
  
  # Days passed in this fiscal month
  def days_passed
    Time.now.utc.to_date - self.beginning_of_month.to_date
  end
  
  # Days passed in this fiscal month, including today
  def days_passed_including_today
    Time.now.utc.to_date - self.beginning_of_month.to_date + 1
  end
  
  # Reset spent_today if daily email
  def reset_spent_today
    self.spent_today = 0 unless self.send_now?
  end
  
  def reset!
    maximum_spending_limit = self.spending_goal + self.savings_goal
    self.temporary_spending_cut = self.spent_this_month - maximum_spending_limit
    if self.temporary_spending_cut < 0
      self.temporary_spending_cut = 0
    end
    self.spent_this_month = 0
    update_reset_at
    self.save
  end
  
  def sent!
    self.failures = 0
    self.send_now = false
    update_send_at
    self.sent_at = Time.now.utc
    self.save
  end
  
  # How much the user should have spent in this period
  def should_have_spent
    self.spending_per_day * self.days_passed_including_today
  end
  
  def spend!(amount)
    amount = amount.to_f if amount.respond_to?(:upcase)
    self.recent_transactions ||= []
    self.recent_transactions.unshift(amount)
    self.spent_this_month += amount
    self.spent_today += amount
    self.send_now = true
    self.save
  end
  
  # Spending goal for the month
  def spending_goal
    read_attribute(:spending_goal) - self.temporary_spending_cut
  end
  
  # Today's spending goal
  def spending_goal_today
    (self.surplus(:exclude_today) / self.days_left_including_today) - self.spent_today
  end
  
  # Today's spending goal with savings included in money left to spend
  def spending_goal_today_savings
    (self.savings_goal + self.surplus(:exclude_today)) / self.days_left_including_today
  end
  
  # How much the user is spending per day (ideally)
  def spending_per_day
    self.spending_goal / self.days_in_month
  end
  
  # How much the user has spent this month
  def spent_this_month(option=nil)
    case option
    when :exclude_today
      read_attribute(:spent_this_month) - self.spent_today
    else
      read_attribute(:spent_this_month)
    end
  end
  
  # Variance from budget based on savings_goal
  def surplus(option=nil)
    two_decimals(self.spending_goal - spent_this_month(option))
  end
  
  # Variance from budget based on should_have_spent
  def surplus_for_period(option=nil)
    two_decimals(self.should_have_spent - spent_this_month(option))
  end
  
  # Total remaining money for the month
  def total_left(option=nil)
    self.surplus(option) + self.savings_goal
  end

  private
  
  def before_create_timestamps
    self.reset_at = update_send_at
    update_reset_at
  end
  
  def before_save_recent_transactions
    if self.recent_transactions
      self.recent_transactions = self.recent_transactions[0..4]
    end
  end
  
  def before_save_savings_goal
    if self.savings
      self.savings_goal = self.savings
    end
  end
  
  def before_save_spending_goal
    if self.income && self.bills && self.savings
      self.spending_goal = self.income - self.bills - self.savings
    end
  end
  
  def local_12am_to_server_time
    time = to_local_time(Time.now)
    time = DateTime.strptime(
      time.strftime("%m/%d/%Y 12:00 AM %Z"),
      "%m/%d/%Y %I:%M %p %Z"
    )
    to_server_time(time.to_time)
  end
  
  def to_local_time(time)
    return time.utc unless self.timezone_offset
    time.utc + self.timezone_offset
  end
  
  def to_number(string)
    string = string.gsub(/[^\d\.]/, '')
    string.blank? ? string : string.to_f
  end
  
  def to_server_time(time)
    return time.utc unless self.timezone_offset
    time.utc - self.timezone_offset
  end
  
  def two_decimals(amount)
    sprintf("%.2f", amount).to_f
  end
  
  def update_reset_at
    self.reset_at = self.reset_at + 1.month
  end
  
  def update_send_at
    if self.send_at
      self.send_at = self.send_at + 1.day
    else
      self.send_at = local_12am_to_server_time
    end
  end
end
