# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_db_column(:title) }
  it { is_expected.to have_db_column(:body) }

  context 'methods' do
    describe '#best_answer' do
      let(:question) { create(:question) }

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
  end

  it 'have one attached attachment' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
