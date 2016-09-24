class Answer < ApplicationRecord
  include Attachable
  include HasUser

  belongs_to :question
  
  validates :body, :question_id, presence: true

  default_scope { order(best: :desc, created_at: :asc )}
  
  def mark_best
    transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end
end
