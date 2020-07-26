require 'spec_helper'

shared_examples_for 'votable' do

  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym, user: user) }
  let!(:votes) { create(:vote, votable: votable, score: 1, user: user_2) }
  let!(:votes_2) { create(:vote, votable: votable, score: 1, user: user_2) }

  describe '#rating' do
    it 'returns summary vote scores for resource' do

      expect(votable.rating).to eq(2)
    end
  end
end
