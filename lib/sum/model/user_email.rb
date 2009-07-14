class UserEmail < ActiveRecord::Base
  
  belongs_to :user
  validates_uniqueness_of :email
  
  def activate!
    self.update_attribute(:active, true)
    self.user.flash = "Successfully re-activated #{self.email}."
    self.user.send_now = true
    self.user.save
  end
  
  def deactivate!
    self.update_attribute(:active, false)
    begin
      $mail.deliver(
        :from => 'sum@sumapp.com',
        :to => self.email,
        :subject => 'Sum deactivated',
        :body => 'Reply with the word "start" to begin receiving emails again.'
      )
      self.sent!
    rescue Exception
      self.increment!(:failures)
    end
  end
  
  def sent!
    self.update_attribute :failures, 0
  end
end
