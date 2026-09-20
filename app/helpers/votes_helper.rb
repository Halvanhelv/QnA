# frozen_string_literal: true

module VotesHelper
  # The signed-in user's votes for a question and its answers, keyed like "Answer:3" => -1.
  # Read by the vote-rail Stimulus controller to mark the buttons.
  def my_votes_json(question)
    return '{}' unless current_user

    votables = [question, *question.answers]
    scores = current_user.votes.where(votable: votables).pluck(:votable_type, :votable_id, :score)
    scores.to_h { |type, id, score| ["#{type}:#{id}", score] }.to_json
  end
end
