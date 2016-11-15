require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "enrolled" do
    let(:mail) { UserMailer.enrolled }

    it "renders the headers" do
      expect(mail.subject).to eq("Enrolled")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "updated" do
    let(:mail) { UserMailer.updated }

    it "renders the headers" do
      expect(mail.subject).to eq("Updated")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "payment_upcoming" do
    let(:mail) { UserMailer.payment_upcoming }

    it "renders the headers" do
      expect(mail.subject).to eq("Payment upcoming")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "payment_cancelled" do
    let(:mail) { UserMailer.payment_cancelled }

    it "renders the headers" do
      expect(mail.subject).to eq("Payment cancelled")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
