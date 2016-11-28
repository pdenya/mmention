class RemoveExtraCommentFields < ActiveRecord::Migration
  def change
  	remove_column :comments, :text
  	remove_column :comments, :thread_title
  	remove_column :comments, :url
  end
end
