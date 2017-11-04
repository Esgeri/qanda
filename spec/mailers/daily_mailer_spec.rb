require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user) }
    let!(:question) { create(:question) }

    it "renders the headers" do
      expect(mail.subject).to eq('Daily digest of questions')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it "mail contains titles of the questions" do
      expect(mail.body.encoded).to match('Daily digest of questions')
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
