class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def owner_of?(object)
    id == object.user_id
  end

  def can_vote?(entity)
    !owner_of?(entity) && !voted?(entity)
  end

  def can_cancel_vote?(entity)
    !owner_of?(entity) && voted?(entity)
  end

  def find_vote(entity)
    entity.votes.where(user: self).first
  end

  def voted?(entity)
    !entity.votes.where(user: self).empty?
  end
end
