# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to  have_db_column(:question_id) }
  it { is_expected.to  have_db_column(:body) }
  it { is_expected.to  have_db_index(:question_id) }
  it { is_expected.to  have_db_column(:best_answer) }

  it_behaves_like 'attachable'
  it_behaves_like 'linkable'

  context 'scope' do
    describe '#ordered_by_best' do
      let!(:answers) { create_list(:answer, 3) }

      context 'without best answer' do
        it { expect(Answer.order_by_best).to match_array(answers) }
      end

      context 'best answer exist' do
        let!(:best_answer) { create(:answer, best_answer: true) }

        it { expect(Answer.order_by_best.first).to eq(best_answer) }
      end

      describe '#best' do
        let!(:answers) { create_list(:answer, 3) }

        context 'without best answer' do
          it { expect(Answer.best).to match_array([]) }
        end

        context ' best answer exist' do
          let!(:best_answer) { create(:answer, best_answer: true) }

          it { expect(Answer.best).to match_array(best_answer) }
        end
      end
    end
  end

  context 'methods' do
    describe '#choose_as_best' do
      let(:question) { create(:question, :with_reward) }
      let(:question_without_reward) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:answer_2) { create(:answer, question: question_without_reward) }
      let!(:answer_3) { create(:answer, question: question) }
      let!(:another_answer) { create(:answer, question: question, best_answer: true) }

      before { answer.make_best_answer }

      it { expect(answer.reload.best_answer).to be_truthy }

      it { expect(another_answer.reload.best_answer).to be_falsey }

      it { expect(answer.user.rewards).to match_array([question.reward]) }

      it { expect(answer.reload.best_answer).to be_truthy }

      it { expect { answer_2.make_best_answer }.to_not change(answer_2.user.rewards, :count) }

      it 'Cancel reply as best answer' do
        answer.make_best_answer
        expect(question.reward.reload.user).to be_nil
      end

      it 'сhange the best answer to another one with the same author' do
        answer_3.make_best_answer
        expect(question.reward.user).to eq(answer_3.user)
      end

    end
  end
end
