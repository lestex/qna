class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @question = Question.find(params[:question_id])
    #@question.answers.create(answer_params.merge(user: current_user))
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    #@answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.owner_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer has been deleted'
    else
      flash[:danger] = 'Answer cannot be deleted'
    end
    redirect_to @answer.question
  end

  private
  def answer_params
    params.require(:answer).permit(:body) 
  end
end
