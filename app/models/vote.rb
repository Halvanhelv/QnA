# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :score, presence: true, inclusion: -1..1
end
