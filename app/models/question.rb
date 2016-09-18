class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  # rails 5 needs inverse_of
  has_many :attachments, inverse_of: :question
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  accepts_nested_attributes_for :attachments
end
