class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.references :video, index: true, foreign_key: true
      t.references :comment, index: true, foreign_key: true
      t.string :link_text

      t.timestamps null: false
    end
  end
end
