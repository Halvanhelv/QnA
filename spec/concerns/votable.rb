# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym, user: user) }
  let!(:votes) { create(:vote, votable: votable, score: 1, user: user_2) }

  describe '#rating' do
    let!(:votes_2) { create(:vote, votable: votable, score: 1, user: user_2) }
    it 'returns summary vote scores for resource' do
      expect(votable.rating).to eq(2)
    end
  end

  describe '#formation_vote' do
    it 'сreates a vote' do
      expect { votable.formation_vote(user, 1) }.to change(Vote, :count).by(1)
    end

    it 'update a vote' do
      votable.formation_vote(user_2, -1)
      expect(votes.reload.score).to eq(-1)
    end
  end

  describe '#user_vote' do
    it 'user score' do
      expect(votable.user_vote(user_2)).to eq(1)
    end
  end

  describe '#user_voted' do
    it 'Returns the user vote' do
      expect(votable.user_voted(user_2)).to match_array([votes])
    end
  end
end
