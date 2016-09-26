module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable
  end

  def vote_rating
    votes.sum(:value)
  end

  def build_vote(params)
    votes.build(params)
  end
end