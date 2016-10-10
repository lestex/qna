class CommentToCommentable < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :commentable_id, :string
    add_column :comments, :commentable_type, :string
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
