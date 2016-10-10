class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :create_answer, only: :show
  after_action :publish_question, only: :create

  include Voted
  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit    
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    if current_user.owner_of?(@question)
      @question.update(question_params)
      respond_with(@question)
    end
  end

  def destroy
    respond_with(@question.destroy!, location: root_path) if current_user.owner_of?(@question)
  end

  private

  def create_answer
    @answer = Answer.new
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
  end
end
