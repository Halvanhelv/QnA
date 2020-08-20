# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:question) { create(:question, user: user) }
  let(:other_user) { create(:user) }
  let(:user) { create(:user) }

  it { is_expected.to have_many(:questions) }
  it { is_expected.to have_many(:answers) }
  it { is_expected.to have_many(:rewards) }
  it { is_expected.to have_many(:oauth_providers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it 'author question' do
    expect(user).to be_author_of(question)
  end

  it 'Other user is not the author of the question' do
    expect(other_user).not_to be_author_of(question)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('#FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      # allow_any_instance_of(FindForOauth).to receive(:call)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
