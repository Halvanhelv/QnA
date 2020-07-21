# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:question) { create(:question, user: user) }
  let(:other_user) { create(:user) }
  let(:user) { create(:user) }

  it { is_expected.to have_many(:questions) }
  it { is_expected.to have_many(:answers) }
  it { is_expected.to have_many(:rewards) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it 'author question' do
    expect(user).to be_author_of(question)
  end

  it 'Other user is not the author of the question' do
    expect(other_user).not_to be_author_of(question)
  end
end
