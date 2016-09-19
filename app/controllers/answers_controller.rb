class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :mark_best, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params) if current_user.owner_of?(@answer)
  end

  def destroy
    @answer.destroy! if current_user.owner_of?(@answer)
  end

  def mark_best
    @question = @answer.question
    @answer.mark_best if current_user.owner_of?(@question)
  end

  private
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file]) 
  end
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
end
