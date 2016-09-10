class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    @question = Question.find(params[:question_id])
    @answer.update(answer_params) if current_user.owner_of?(@answer)
  end

  def destroy
    @answer.destroy! if current_user.owner_of?(@answer)
  end

  private
  def answer_params
    params.require(:answer).permit(:body) 
  end
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
end
