# frozen_string_literal: true

class DownvotesController < ApplicationController
  include Voting

  private

  def score = -1
end
