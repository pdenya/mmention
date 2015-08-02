class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :thread_url
      t.text :text
      t.string :user
      t.datetime :posted_at
      t.string :subreddit

      t.timestamps null: false
    end
  end
end
