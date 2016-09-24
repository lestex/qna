class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def owner_of?(object)
    id == object.user_id
  end

  def can_vote?(object)
    !owner_of?(object) && !voted?(object)
  end

  def can_cancel_vote?(object)
    !owner_of?(object) && voted?(object)
  end

  def find_vote(object)
    object.votes.where(user: self).first
  end

  def voted?(object)
    !object.votes.where(user: self).empty?
  end
end
