class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.boolean :opened, :default => true
      t.integer :user_id
      t.timestamp :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
