class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  scope :all_except, ->(user) { where.not(id: user) }

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

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return User.new unless email
    
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.build_with_email(params, auth)
    password = Devise.friendly_token[0, 20]
    user = User.where(email: params[:user][:email]).first
    user ||= User.create!(email: params[:user][:email], 
      password: password,
      password_confirmation: password)
    user.authorizations.create(provider: auth["provider"], uid: auth["uid"].to_s)
    user
  end

  def subscribed?(object)
    object.subscriptions.where(user_id: id).present?
  end

  def self.send_questions
    self.send_daily_digest
  end

  def self.send_daily_digest

    find_each.each do |user|
      DailyMailer.digest(user, Question.created_day_before.all.entries).deliver_later
    end
  end
end
