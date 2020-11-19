# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'voted' do
  describe 'PATCH #positive_vote' do
    subject { patch :positive_vote, params: { id: votable, format: :json } }
    context 'no votable author' do
      before { login(user) }

      it 'assigns the requested votable to @votable' do
        subject
        expect(assigns(:votable)).to eq votable
      end

      it 'vote save in database' do
        expect { subject }.to change(Vote, :count).by(1)
      end

      it 'render JSON response' do
        subject
        expect(JSON.parse(response.body)['rating']).to eq(votable.reload.rating)
      end

      it 'can not vote for resource twice' do
        subject
        subject
        expect(votable.reload.rating).to eq(1)
      end
    end

    context 'As an author of resource' do
      before { login(user_2) }
      it 'can not vote for resource' do
        subject
        expect(votable.reload.rating).to eq(0)
      end

      # it 'render JSON response' do
      #   subject
      #   expect(response.status).to eq(422)
      #   expect(response.body).to have_content('You cannot vote for yourself')
      # end
    end

    context 'As guest' do
      it 'can not vote for resource' do
        subject
        expect(votable.reload.rating).to eq(0)
      end

      it 'render JSON response' do
        subject
        expect(response.status).to eq(401)
      end
    end
  end
end
