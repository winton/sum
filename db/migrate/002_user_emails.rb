class UserEmails < ActiveRecord::Migration
  def self.up
    create_table :user_emails do |t|
      t.column :active, :boolean, :default => true
      t.column :email, :string
      t.column :failures, :integer, :default => 0
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :user_emails
  end
end
