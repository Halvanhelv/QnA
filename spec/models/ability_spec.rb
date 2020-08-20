require 'rails_helper'
describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Link }
    it { should_not be_able_to :read, Reward }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, :with_files, user: user) }
    let(:question_2) { create(:question, :with_files,:with_links, user: other) }
    let(:answer_2) { create(:answer, :with_files, user: other, question: question_2) }
    let(:answer) { create(:answer, :with_files, user: user, question: question) }
    let(:link) { create(:link) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should_not be_able_to %i[positive_vote negative_vote], question }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question }
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :update, question_2 }
      it { should_not be_able_to :destroy, question_2 }
      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, question_2.files.first }
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: question_2) }

    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, answer_2 }
      it { should_not be_able_to :destroy, answer_2 }
      it { should be_able_to :destroy, answer.files.first }
      it { should_not be_able_to :destroy, answer_2.files.first }
      it { should_not be_able_to :destroy, create(:link, linkable: answer_2) }
      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should be_able_to :best_answer, answer }
      it { should_not be_able_to :best_answer, answer_2 }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update, create(:comment, user: user, commentable: question) }
      it { should_not be_able_to :update, create(:comment, user: other, commentable: question) }
      it { should be_able_to :destroy, create(:comment, user: user, commentable: question) }
      it { should_not be_able_to :destroy, create(:comment, user: other, commentable: question_2) }
    end
  end
end
