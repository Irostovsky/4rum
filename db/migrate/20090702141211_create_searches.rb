class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :keywords
      t.string :place, :default => 'all'
      t.string :occurrence, :default => 'full'
      t.timestamp :date_from
      t.timestamp :date_to
      t.string :selected_topics
      t.string :selected_users
    end
  end

  def self.down
    drop_table :searches
  end
end
