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
  
  def beginning_of_month # Beginning of fiscal month
    self.reset_at - 1.month
  end
  
  def days_in_month # Days in this fiscal month
    self.reset_at - self.beginning_of_month
  end
  
  def days_left # Days left in this fiscal month
    self.reset_at.to_date - Time.now.to_date
  end
  
  def days_passed # Days passed in this fiscal month
    Time.now.to_date - self.beginning_of_month.to_date
  end
  
  def deliver!
    begin
      $mail.deliver(
        :from => 'sum@sumapp.com',
        :to => self.email,
        :subject => "Today's budget",
        :body => erb(:email, :locals => { :u => self })
      )
      self.failures = 0
      self.update_send_at
      self.sent_at = Time.now.utc
      self.save
    rescue Exception
      self.failures.increment!
    end
  end
  
  def money_left # Money left to spend in this fiscal month
    self.spending_goal - self.spent_this_month
  end
  
  def potential_savings # Money that will be saved if daily spending goal is met
    (self.savings_per_day * self.days_left) + self.surpus
  end
  
  def reset!
    maximum_spending_limit = self.spending_goal + self.savings_goal
    self.temporary_spending_cut = self.spent_this_month - maximum_spending_limit
    if self.temporary_spending_cut < 0
      self.temporary_spending_cut = 0
    end
    self.spent_this_month = 0
    self.update_reset_at
    self.save
  end
  
  def savings_per_day # How much the user is saving per day (ideally)
    self.savings_goal / self.days_in_month
  end
  
  def should_have_spent # How much the user should have spent in this period
    self.spending_per_day * self.days_passed
  end
  
  def spending_goal # Spending goal for the month
    read_attribute(:spending_goal) - self.temporary_spending_cut
  end
  
  def spending_goal_today # Today's spending goal
    self.money_left / self.days_left
  end
  
  def spending_goal_today_savings # Today's spending goal (don't go into debt edition)
    (self.savings_goal - self.money_left) / self.days_left
  end
  
  def spending_per_day # How much the user is spending per day (ideally)
    self.spending_goal / self.days_in_month
  end
  
  def surplus # How much money currently over or under budget
    self.should_have_spent - self.spent_this_month
  end

  private
  
  def before_create_timestamps
    self.reset_at = update_send_at
    update_reset_at
  end
  
  def before_save_recent_transactions
    if self.recent_transactions.respond_to?(:index)
      self.recent_transactions = self.recent_transactions[0..9]
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
  
  def next_5am(time)
    time = to_local(time)
    time = DateTime.strptime(
      time.strftime("%m/%d/%Y 05:00 AM %Z"),
      "%m/%d/%Y %I:%M %p %Z"
    )
    time = time.to_time
    if to_local(Time.now) > time
      time + 1.day
    else
      time
    end
  end
  
  def to_local(time)
    return time unless self.timezone_offset
    time.utc + self.timezone_offset
  end
  
  def to_number(string)
    string = string.gsub(/[^\d\.]/, '')
    string.blank? ? string : string.to_f
  end
  
  def update_reset_at
    self.reset_at = self.reset_at + 1.month
  end
  
  def update_send_at
    if self.send_at
      self.send_at = self.send_at + 1.day
    else
      self.send_at = next_5am(Time.now) - self.timezone_offset
    end
  end
end
