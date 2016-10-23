class QuestionDetailsSerializer < QuestionSerializer
  has_many :comments
  has_many :attachments
end