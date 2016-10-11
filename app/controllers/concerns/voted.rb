module Voted
  extend ActiveSupport::Concern
  include FormatHelper

  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :find_vote, only: :reject_vote

    respond_to :json, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def vote_cancel
    respond_with(@vote.destroy) do |format|
      format.json { render json: { rating: format_likes(@votable.vote_rating), id: @votable.id } }
    end if @vote
  end

  private
  def load_votable
    @votable = params[:controller].classify.constantize.find(params[:id])
  end

  def find_vote
    @vote = current_user.find_vote(@votable)
  end

  def vote(num)
    respond_with(@vote = @votable.votes.create(value: num, user: current_user)) do |format|
      format.json { render json: { rating: format_likes(@votable.vote_rating), id: @votable.id } }
    end unless current_user.owner_of?(@votable)
  end
end