class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def owner_of?(object)
    id == object.user_id
  end
end
