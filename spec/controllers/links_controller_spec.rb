require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  before { login(user) }
  describe '#DELETE destroy' do
    describe 'Question links delete' do
      subject { post :destroy, params: { id: question.links.first, format: :js } }

      context 'user is question owner' do
        let!(:question) { create(:question, :with_link, user: user) }

        it { expect { subject }.to change(Link, :count).by(-1) }
      end

      context 'user is no question owner' do
        let!(:question) { create(:question, :with_link, user: another_user) }

        it { expect { subject }.to_not change(Link, :count) }

        it 'redirect to question' do
          subject
          expect(response).to redirect_to question
        end
      end
    end

    describe 'Answer links delete' do
      subject { post :destroy, params: { id: answer.links.first, format: :js } }

      context 'user is answer owner' do
        let!(:answer) { create(:answer, :with_link, user: user) }

        it { expect { subject }.to change(Link, :count).by(-1) }
      end

      context 'user is no answer owner' do
        let!(:answer) { create(:answer, :with_link, user: another_user) }

        it { expect { subject }.to_not change(Link, :count) }

        it 'redirect to question' do
          subject
          expect(response).to redirect_to answer.question
        end
      end
    end
  end
end
