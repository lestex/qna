class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  before_action :load_question, only: :create

  include Voted
  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    if current_user.owner_of?(@answer)
      @answer.update(answer_params)
      respond_with(@answer)
    end
  end

  def destroy
    respond_with(@answer.destroy!) if current_user.owner_of?(@answer)
  end

  def mark_best
    @question = @answer.question
    respond_with(@answer.mark_best) if current_user.owner_of?(@question)
  end

  private
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file]) 
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
end
