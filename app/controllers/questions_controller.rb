class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @comment = @question.comments.build
    @answer.attachments.build
    @answer.comments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit    
  end

  def create
    @question = Question.create(question_params)
    @question.user = current_user
    if @question.save
      PrivatePub.publish_to "/questions", question: @question.to_json
      flash[:success] = 'question created successfully'
      redirect_to @question
    else
      flash.now[:danger] = @question.errors.full_messages
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.owner_of?(@question)
  end

  def destroy
    if current_user.owner_of?(@question)
      @question.destroy
      flash[:success] = 'Question deleted successfully'      
    else
      flash.now[:danger] = 'You cannot delete this question'      
    end
    redirect_to questions_path
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
