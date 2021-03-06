class CreatePostsTags < ActiveRecord::Migration
  def change
    create_table :posts_tags do |t|
      t.references :post
      t.references :tag

      t.timestamps
    end
    add_index :posts_tags, :post_id
    add_index :posts_tags, :tag_id
  end
end
