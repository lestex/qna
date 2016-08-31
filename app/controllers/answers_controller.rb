class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:success] = 'Created an answer'
      redirect_to @question
    else
      flash[:danger] = @answer.errors.full_messages
      redirect_to @question
    end
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
