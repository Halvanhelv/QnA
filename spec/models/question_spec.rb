# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:answers) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_one(:reward) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_db_column(:title) }
  it { is_expected.to have_db_column(:body) }

  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  it { is_expected.to have_many(:subscribers).through(:subscriptions).dependent(:destroy) }

  it_behaves_like 'attachable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  context 'methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    describe '#best_answer' do
      context 'with best answer' do
        let!(:answer) { create(:answer, question: question, best_answer: true) }

        it { expect(question.reload.best_answer).to eq(answer) }
      end

      context 'without best answer' do
        let!(:answer) { create(:answer, question: question, best_answer: false) }

        it { expect(question.reload.best_answer).to eq(nil) }
      end

      context 'without answers' do
        it { expect(question.reload.best_answer).to eq(nil) }
      end
    end

    describe '#subscribed?' do
      it 'user subscribed' do
        expect(question).to be_subscribed(user)
      end

      it 'user not subscribed' do
        expect(question).to_not be_subscribed(other_user)
      end
    end
  end
end
