require 'rails_helper'
feature 'Users can vote for a question', "
To assess the value of the question
As an authorized user
I would like to be able to vote on a question
" do

  describe 'User try' do

    given(:user)      { create(:user) }
    given!(:question) { create(:question, user: user) }

    context 'Authenticated user' do

      background { sign_in(user) }
      background {  visit question_path(question) }

      scenario 'try vote for the question' do
        within '#question' do
          within "#vote-id-#{question.id}" do
          click_on '+'
          end
          expect(page).to have_content "vote for : 1"
        end
        expect(page).to have_content 'You supported the question'
      end

      scenario 'try vote twice on a question'

      scenario 'try vote against question'

      scenario 'try change your vote'

      scenario 'try view question rating'

      scenario 'author of the question  try vote for the question'

    end

  end

end