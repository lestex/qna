class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, :question_id, :user_id, presence: true
end
