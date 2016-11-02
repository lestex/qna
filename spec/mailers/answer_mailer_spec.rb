require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "digest" do
    let(:user) { create :user }
    let(:mail) { AnswerMailer.digest(user) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end
  end
end
