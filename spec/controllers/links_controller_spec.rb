require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  before { login(user) }
  describe '#DELETE destroy' do
    shared_examples 'return 422 http status' do
      it 'return 422 http status' do
        subject
        expect(response).to have_http_status(422)
      end
    end
    describe 'Question links delete' do
      subject { post :destroy, params: { id: question.links.first, format: :js } }

      context 'user is question owner' do
        let!(:question) { create(:question, :with_link, user: user) }

        it { expect { subject }.to change(Link, :count).by(-1) }
      end

      context 'user is no question owner' do
        let!(:question) { create(:question, :with_link, user: another_user) }

        it { expect { subject }.to_not change(Link, :count) }

        include_examples 'return 422 http status'
      end
    end

    describe 'Answer links delete' do
      subject { post :destroy, params: { id: answer.reload.links.first, format: :js } } # добавил reload поскольку в модели у меня вызывается links(для ActionCable) до того как links будут добавлены  и после в памяти остается инфа что у answer нет links и не идет обращение к бд

      context 'user is answer owner' do
        let!(:answer) { create(:answer, :with_link, user: user) }

        it { expect { subject }.to change(Link, :count).by(-1) }
      end

      context 'user is no answer owner' do
        let!(:answer) { create(:answer, :with_link, user: another_user) }

        it { expect { subject }.to_not change(Link, :count) }

        include_examples 'return 422 http status'
      end
    end
  end
end
