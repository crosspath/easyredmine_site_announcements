# coding: UTF-8

class AlterDateFields < ActiveRecord::Migration
  def up
    change_table :announcements do |t|
      t.change :starts_at, :date
      t.change :ends_at, :date
    end
    add_index :announcements, [:starts_at, :ends_at]
  end
  
  def down
    change_table :announcements do |t|
      t.change :starts_at, :datetime
      t.change :ends_at, :datetime
    end
    drop_index :announcements, [:starts_at, :ends_at]
  end
end
