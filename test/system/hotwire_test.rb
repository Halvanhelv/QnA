# frozen_string_literal: true

require 'application_system_test_case'

class HotwireTest < ApplicationSystemTestCase
  include ActionView::RecordIdentifier

  test 'owner controls are revealed only to the owner' do
    sign_in_through_form(users(:alice))

    visit question_path(questions(:rails))
    assert_button 'Delete', exact: true
    assert_link 'Edit', exact: true

    visit question_path(questions(:hotwire))
    assert_no_button 'Delete', exact: true
    assert_no_link 'Edit', exact: true
  end

  test 'new questions appear live on the index page' do
    visit root_path

    using_session(:author) do
      sign_in_through_form(users(:bob))
      visit new_question_path
      fill_in 'Title', with: 'Live question'
      fill_in 'Details', with: 'Appears without reload'
      click_on 'Post question'
      assert_text 'Your question successfully created.'
    end

    assert_selector '#questions li', text: 'Live question'
  end

  test 'answers, comments and votes update pages live' do
    question = questions(:rails)

    using_session(:watcher) { visit question_path(question) }

    sign_in_through_form(users(:bob))
    visit question_path(question)

    fill_in 'Answer', with: 'A brand new live answer'
    click_on 'Post answer'
    assert_selector '#answers', text: 'A brand new live answer'
    assert_field 'answer_body', with: ''

    using_session(:watcher) do
      assert_selector '#answers', text: 'A brand new live answer'
      assert_no_button 'Delete answer'
    end

    within "##{dom_id(question)}" do
      click_on 'Add comment'
      fill_in 'Comment', with: 'A live comment here'
      click_on 'Post comment'
    end

    assert_selector "##{dom_id(question, :comments)}", text: 'A live comment here'
    using_session(:watcher) { assert_selector "##{dom_id(question, :comments)}", text: 'A live comment here' }

    within "##{dom_id(question)}" do
      click_on 'Upvote'
      assert_selector "##{dom_id(question, :rating)}", text: '1'
    end
  end

  test 'the author edits an answer in place' do
    sign_in_through_form(users(:bob))
    visit question_path(questions(:rails))

    click_on 'Edit answer'
    within "##{dom_id(answers(:step_by_step), :edit)}" do
      fill_in 'Your answer', with: 'Edited in place'
      click_on 'Save changes'
    end

    assert_selector '#answers', text: 'Edited in place'
  end

  test 'nested link fields can be added and removed' do
    sign_in_through_form(users(:alice))
    visit new_question_path

    click_on 'Add link'
    click_on 'Add link'
    assert_selector '.nested-fields', count: 2

    first('.nested-fields').click_on 'Remove link'
    assert_selector '.nested-fields', count: 1
  end
end
