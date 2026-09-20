# frozen_string_literal: true

class Tagging < ApplicationRecord
  # Touching the question keeps its search entry (which includes the tags) fresh
  belongs_to :question, touch: true
  belongs_to :tag, counter_cache: :taggings_count
end
