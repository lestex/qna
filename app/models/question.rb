class Question < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true

  scope :created_day_before, ->() { where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }
end
