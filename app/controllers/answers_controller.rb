class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    if @question.answers.create(answer_params)
      redirect_to @question
    else
      render question_path(@question)
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body)    
  end
end
