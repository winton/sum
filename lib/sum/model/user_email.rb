class UserEmail < ActiveRecord::Base
  
  belongs_to :user
  validates_uniqueness_of :email
  
  def sent!
    self.update_attribute :failures, 0
  end
end
