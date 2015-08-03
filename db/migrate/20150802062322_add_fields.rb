class AddFields < ActiveRecord::Migration
  def change
  	add_column :comments, :thread_title, :string
  	add_column :comments, :url, :string
  	add_column :comments, :remote_id, :string
  end
end
