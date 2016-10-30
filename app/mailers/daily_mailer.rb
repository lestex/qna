class DailyMailer < ApplicationMailer
  def digest(user, questions)    
    mail to: user.email
    mail subject: 'Quetions digest'
    mail body: questions.map { |question| question.title }
  end
end
