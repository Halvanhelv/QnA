# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:score)
  end

  def vote_by(user)
    votes.find_by(user: user)
  end

  def score_by(user)
    vote_by(user)&.score.to_i
  end

  # Casting the same score again takes the vote back. Returns true when the vote stands afterwards.
  def toggle_vote(user, score)
    vote = vote_by(user)

    if vote&.score == score
      vote.destroy
      false
    else
      cast_vote(user, score)
      true
    end
  end

  def cast_vote(user, score)
    vote = vote_by(user)
    vote ? vote.update(score: score) : votes.create(score: score, user: user)
  end
end
