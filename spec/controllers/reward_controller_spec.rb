require 'rails_helper'

RSpec.describe RewardController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    subject { post :create, params: { question_id: question, answer: answer_params, format: :js } }

    before { login(user) }
    context 'Delete question ' do
    end
  end
end
