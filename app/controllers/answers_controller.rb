class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_answer, only: [:destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answer.save
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
