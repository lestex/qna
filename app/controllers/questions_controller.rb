class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question)    
  end

  def new
    @question = Question.new
  end

  def edit    
  end

  def create
    @question = Question.create(question_params)
    @question.user = current_user
    if @question.save      
      flash[:success] = 'question created successfully'
      redirect_to @question
    else
      flash.now[:danger] = @question.errors.full_messages
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
