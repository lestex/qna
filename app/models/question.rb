class Question < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  validates :title, :body, presence: true

  after_create :subscribe_author

  scope :created_day_before, ->() { where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }

  def subscribe_author
    self.subscriptions.create(user_id: user_id) if self.valid?
  end
end
