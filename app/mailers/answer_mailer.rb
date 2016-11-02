class AnswerMailer < ApplicationMailer
  def digest(user)
    mail to: user.email
    mail subject: "You have a new answer"
  end
end
