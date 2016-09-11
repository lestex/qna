class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc, created_at: :asc )}

  def mark_best
    unless best
      question.answers.update_all(best: false)
      update(best: true)
    end
  end
end
