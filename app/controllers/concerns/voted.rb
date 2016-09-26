module Voted
  extend ActiveSupport::Concern
  include FormatHelper

  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def vote_cancel
    @vote = current_user.find_vote(@votable)
    if @vote
      respond_to do |format|
        if @vote.destroy
          format.json { render json: { rating: format_likes(@votable.vote_rating), id: @votable.id } }
        else
          format.json do
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    end
  end

  private
   def load_votable
     @votable = params[:controller].classify.constantize.find(params[:id])
   end

  def vote(num)
    unless current_user.owner_of?(@votable)
      @vote = @votable.build_vote(value: num, user: current_user)
      respond_to do |format|
        if @vote.save
          format.json { render json: { rating: format_likes(@votable.vote_rating), id: @votable.id } }
        else
          format.json do
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    end
  end
end