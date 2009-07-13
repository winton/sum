class UserEmails < ActiveRecord::Migration
  def self.up
    create_table :user_emails do |t|
      t.column :email, :string
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :user_emails
  end
end
