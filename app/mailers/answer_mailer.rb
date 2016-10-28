class AnswerMailer < ApplicationMailer
  def digest(user, question)
    mail to: user.email
    mail subject: 'New answer for #{question.title}!'
  end
end
