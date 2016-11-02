class AddsUserAndQuestionToSubscription < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :subscriptions, :question, index: true, foreign_key: true
    add_belongs_to :subscriptions, :user, index: true, foreign_key: true
  end
end
