class ChangeToVote < ActiveRecord::Migration[5.0]
  def change
    remove_index :votes, [:votable_id, :votable_type]
    rename_column :votes, :count, :value
    change_column :votes, :value, :integer, default: 0, null: false
    add_index :votes, [:votable_type, :votable_id]
  end
end
