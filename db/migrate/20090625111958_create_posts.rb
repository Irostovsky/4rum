class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.text :content
      t.integer :user_id
      t.integer :topic_id
      t.timestamp :created_at
      t.timestamp :updated_at

    end
  end

  def self.down
    drop_table :posts
  end
end
