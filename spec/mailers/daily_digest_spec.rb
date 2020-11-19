# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2, created_at: Time.now) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('List of new questions per day:')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials[:test][:gmail][:email]])
    end

    it 'renders the body' do
      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end
