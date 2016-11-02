class DailyMailer < ApplicationMailer
  def digest(user, questions)    
    mail to: user.email
    mail subject: 'Digest'
    mail body: questions.map { |question| question.title }.join('\n')
  end
end
