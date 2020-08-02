require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'POST #create' do
    context 'Authenticated user' do


      context 'for question' do

        context 'with correct attributes' do
          it 'create comment'

          it 'comment saves with correct question'

          it 'comment saves with correct author'

          it 'render create view'

          it 'streaming to channel'


        end
        context 'with invalid attributes' do

          it 'does not save the comment'

          it 're-render create view'

          it 'do not streaming to channel'

        end

      end

      context 'for answer' do
        context 'with correct attributes' do

          it 'create comment'

          it 'comment saves with correct question'

          it 'comment saves with correct author'

          it 'render create view'

          it 'streaming to channel'
        end

        context 'with invalid attributes' do
          it 'does not save the comment'

          it 're-render create view'

          it 'do not streaming to channel'

        end
      end

    end

    context 'As guest' do
      it 'does not create the comment for resource'

      it 'responds with 401'

      it 'redirect to sign in page'

    end
  end
end
