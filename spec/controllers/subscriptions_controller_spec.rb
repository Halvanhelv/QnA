require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, question: question, user: user) }
  describe 'PATCH #subscribe' do
    context 'User authorized' do
      before do
        login(user)
        delete :destroy, params: { id: subscription, format: :js } # при создании вопроса, колбэк создает подписку и нужно для начала от нее отказаться для проверки работы подписки
      end
      it 'saves a new subscription in the database' do
        expect do
          post :create, params: { question_id: question, format: :js }
        end.to change(question.subscriptions, :count).by(1)
      end

      it 'render subscribe view' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
    context 'Guest' do
      it 'try subscribe to question' do
        expect do
          post :create, params: { question_id: question, format: :js }
        end.to_not change(question.subscriptions, :count)
      end

      it 'status Code: 401 Unauthorized' do
        post :create, params: { question_id: question, format: :js }
        expect(response.status).to eq 401
      end
    end
  end
  describe 'DELETE #unsubscribe' do
    context 'User authorized' do
      before do
        login(user)
      end
      it 'delete a subscription in the database' do
        expect do
          delete :destroy, params: { id: subscription, format: :js }
        end.to change(question.subscriptions, :count).by(-1)
      end
      it 'render unsubscribe view' do
        delete :destroy, params: { id: subscription, format: :js }

        expect(response).to render_template :destroy
      end
    end
    context 'Guest' do
      it 'try unsubscribe to question' do
        expect do
          delete :destroy, params: { id: question, format: :js }
        end.to_not change(question.subscriptions, :count)
      end
      it 'status Code: 401 Unauthorized' do
        delete :destroy, params: { id: question, format: :js }
        expect(response.status).to eq 401
      end
    end
  end
end
