# frozen_string_literal: true

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
    let(:question_2) { create(:question, :with_files, :with_links, user: other) }
    let(:answer_2) { create(:answer, :with_files, user: other, question: question_2) }
    let(:answer) { create(:answer, :with_files, user: user, question: question) }
    let(:link) { create(:link) }
    let(:subscription) { create(:subscription, question: question_2, user: user) }
    let(:subscription1) { create(:subscription, question: question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should_not be_able_to %i[positive_vote negative_vote], question }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, question }
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :update, question_2 }
      it { should_not be_able_to :destroy, question_2 }
      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, question_2.files.first }
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: question_2) }
    end

    describe 'Subscription' do
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, subscription }
      it { should_not be_able_to :destroy, subscription1 }
    end

    context 'Answer' do
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

    context 'Comment' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update, create(:comment, user: user, commentable: question) }
      it { should_not be_able_to :update, create(:comment, user: other, commentable: question) }
      it { should be_able_to :destroy, create(:comment, user: user, commentable: question) }
      it { should_not be_able_to :destroy, create(:comment, user: other, commentable: question_2) }
    end
  end
end
