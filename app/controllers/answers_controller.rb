class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    if @question.answers.create(answer_params)
      redirect_to @question
    else
      render :new
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body) 
  end
end
