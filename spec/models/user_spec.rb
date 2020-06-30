# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'author question' do
    expect(user).to be_author_of(question)
  end

  it 'Other user is not the author of the question' do
    expect(user1).not_to be_author_of(question)
  end
end
