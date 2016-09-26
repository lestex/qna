class VoteToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :votable_id, :string
    add_column :votes, :votable_type, :string
    add_index :votes, [:votable_id, :votable_type]
  end
end
