class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :recent_transactions, :string, :size => 1024
      t.column :savings_goal, :decimal, :precision => 10, :scale => 2
      t.column :spending_goal, :decimal, :precision => 10, :scale => 2
      t.column :spent_this_month, :decimal, :precision => 10, :scale => 2
      t.column :temporary_spending_reduction, :decimal, :precision => 10, :scale => 2
      t.column :send_at, :datetime
      t.column :reset_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
