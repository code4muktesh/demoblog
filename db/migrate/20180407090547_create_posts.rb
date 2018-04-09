class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.references :user
      t.references :category
      t.string :comment_count
      t.text :tags

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :category_id
  end
end
