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
  
  def deliver!
    begin
      $mail.deliver(
        :from => 'sum@sumapp.com',
        :to => self.email,
        :subject => "Today's budget",
        :body => erb(:email, :locals => { :user => self })
      )
      self.update_attribute(:failures, 0)
    rescue Exception
      self.failures.increment!
    end
  end
  
  def reset!
    maximum_spending_limit = self.spending_goal + self.savings_goal
    self.temporary_spending_cut = self.spent_this_month - maximum_spending_limit
    if self.temporary_spending_cut < 0
      self.temporary_spending_cut = 0
    end
    self.spend_this_month = 0
    self.update_reset_at
    self.save
  end
  
  def spending_goal
    read_attribute(:spending_goal) - self.temporary_spending_cut
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
    self.send_at = next_5am(Time.now) - self.timezone_offset
  end
end
