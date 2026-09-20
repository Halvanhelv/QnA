# frozen_string_literal: true

class Tagging < ApplicationRecord
  belongs_to :question
  belongs_to :tag, counter_cache: :taggings_count
end
