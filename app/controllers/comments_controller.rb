class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  after_action :publish_to, only: :create

  respond_to :json
  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
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

  def publish_to
    PrivatePub.publish_to channel_name, comment: @comment.to_json if @comment.valid?
  end

end
