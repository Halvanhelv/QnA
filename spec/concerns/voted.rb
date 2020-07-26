require 'rails_helper'

shared_examples_for 'voted' do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:controller) { described_class }
  let(:model) { controller.controller_name.classify.constantize }


  describe 'PATCH #positive_vote' do
    before { login(user) }

    context 'no votable author' do
      subject {   patch :positive_vote, params: { id: votable, format: :json } }

      it 'assigns the requested votable to @votable' do
        subject
        expect(assigns(:votable)).to eq votable
      end

      it 'vote save in database' do
        expect { subject }.to change(Vote, :count).by(1)
      end

    end
    

  end
end