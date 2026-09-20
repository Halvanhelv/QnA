# frozen_string_literal: true

require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test 'guest can only read, except rewards' do
    ability = Ability.new(nil)
    assert ability.can?(:read, Question)
    assert ability.cannot?(:read, Reward)
    assert ability.cannot?(:create, Question)
  end

  test 'admin can manage everything' do
    assert Ability.new(users(:admin)).can?(:manage, :all)
  end

  test 'user manages own resources only' do
    ability = Ability.new(users(:alice))
    own = questions(:rails)
    foreign = questions(:hotwire)

    assert ability.can?(:create, Question)
    assert ability.can?(:update, own)
    assert ability.can?(:destroy, own)
    assert ability.cannot?(:update, foreign)
    assert ability.cannot?(:destroy, foreign)
  end

  test 'user cannot vote for own resources but can for others' do
    ability = Ability.new(users(:alice))
    assert ability.cannot?(:vote, questions(:rails))
    assert ability.can?(:vote, questions(:hotwire))
    assert ability.can?(:vote, answers(:step_by_step))
  end

  test 'only the question author accepts the best answer' do
    answer = answers(:step_by_step)
    assert Ability.new(users(:alice)).can?(:accept, answer)
    assert Ability.new(users(:bob)).cannot?(:accept, answer)
  end

  test 'user destroys own links' do
    link = links(:guide)
    assert Ability.new(users(:alice)).can?(:destroy, link)
    assert Ability.new(users(:bob)).cannot?(:destroy, link)
  end
end
