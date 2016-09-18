class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable

  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc, created_at: :asc )}
  accepts_nested_attributes_for :attachments
  
  def mark_best
    transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end
end
