class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url
      t.string :title
      t.datetime :posted_at

      t.timestamps null: false
    end
  end
end
