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
      fill_in_editor 'Appears without reload'
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

    fill_in_editor 'A brand new live answer', within: '#new-answer'
    click_on 'Post answer'
    assert_selector '#answers', text: 'A brand new live answer'
    assert_no_selector '#new-answer lexxy-editor', text: 'A brand new live answer'

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
    fill_in_editor 'Edited in place', within: "##{dom_id(answers(:step_by_step), :edit)}"
    within("##{dom_id(answers(:step_by_step), :edit)}") { click_on 'Save changes' }

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

  test 'search scope is a Choices.js select that submits its value' do
    visit root_path
    find('.choices').click
    find('.choices__item--choice', text: 'users').click

    fill_in 'Search', with: 'alice', match: :first
    find('input[type=submit]').click

    assert_text '1 result'
    assert_selector '.choices__list--single .choices__item', text: 'users'

    page.go_back
    assert_selector '.choices', count: 1
  end

  test 'your vote stays highlighted and cancels on a second click' do
    sign_in_through_form(users(:alice))
    visit question_path(questions(:hotwire))

    click_on 'Upvote'
    assert_selector "button[aria-label='Upvote'][aria-pressed='true']"

    page.refresh
    assert_selector "button[aria-label='Upvote'][aria-pressed='true']"

    click_on 'Upvote'
    assert_selector "button[aria-label='Upvote'][aria-pressed='false']"
  end

  test 'deleting an answer asks for confirmation' do
    sign_in_through_form(users(:bob))
    visit question_path(questions(:rails))

    dismiss_confirm { click_on 'Delete answer' }
    assert_selector '#answers', text: 'Upgrade one minor at a time'

    accept_confirm { click_on 'Delete answer' }
    assert_no_selector '#answers', text: 'Upgrade one minor at a time'
  end

  test 'a new answer scrolls into view for its author and is highlighted' do
    sign_in_through_form(users(:bob))
    visit question_path(questions(:hotwire))

    fill_in_editor 'Posted with the keyboard shortcut', within: '#new-answer'
    find('#new-answer lexxy-editor [contenteditable]').send_keys([:control, :enter])

    assert_selector '#answers article.arrival', text: 'Posted with the keyboard shortcut'
  end
end
