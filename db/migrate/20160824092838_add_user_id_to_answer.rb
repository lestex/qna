class AddUserIdToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :answers, :user, foreign_key: true, index: true
  end
end
