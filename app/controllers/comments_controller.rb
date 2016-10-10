class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]

  def create
    @comment = @commentable.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        PrivatePub.publish_to channel_name, comment: @comment.to_json
        format.json { render json: @comment }
      else
        format.json do
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    commentable_id = params.keys.detect { |k| k.to_s =~ /(question|answer)_id/ } 
    klass = $1.classify.constantize
    @commentable = klass.find(params[commentable_id]) 
  end

  def channel_name
    if @commentable.instance_of? Question
       id = @commentable.id
     elsif @commentable.instance_of? Answer
       id = @commentable.question.id
     end
     "/questions/#{id}/comments"
  end

end
