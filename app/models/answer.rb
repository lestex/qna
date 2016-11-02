class Answer < ApplicationRecord
  include Votable
  include Attachable
  include HasUser
  include Commentable

  belongs_to :question
  
  validates :body, :question_id, presence: true

  default_scope { order(best: :desc, created_at: :asc )}

  after_create :new_answer_notification
  
  def mark_best
    transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end

  private
  def new_answer_notification
    AnswerMailer.digest(self.question.user).deliver_later
  end
end
