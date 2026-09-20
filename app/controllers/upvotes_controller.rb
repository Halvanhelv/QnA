# frozen_string_literal: true

class UpvotesController < ApplicationController
  include Voting

  private

  def score = 1
end
