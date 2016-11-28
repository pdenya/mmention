class AddVideoIsHidden < ActiveRecord::Migration
  def change
  	add_column :videos, :is_hidden, :boolean, :default => false
  end
end
