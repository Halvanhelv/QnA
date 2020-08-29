# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
      end
  end

  def guest_abilities
    can :read, :all
    cannot :read, Reward # что бы посмотреть награды юзер должен войти
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can [:positive_vote, :negative_vote], [Question, Answer] do |vote|
      !user.author_of?(vote)
    end
    can :read, :all
    can :me, User,{ user_id: user.id }
    can :best_answer, Answer, question: { user_id: user.id }
    can :create, [Question, Answer, Comment, Link]
    can :update, [Question, Answer, Comment], { user_id: user.id }
    can :destroy, [Question, Answer, Comment], { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }
  end
end
