# frozen_string_literal: true

# Full-text search (PostgreSQL) for a model.
# Provides `Model.search_text(query)` and registers the model in the global multisearch index.
#
#   searchable_by :title, rich_text: :body
#
# Plain columns are searched directly; Action Text attributes are searched through their
# plain-text version (`plain_body`) so markup never matches.
module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def searchable_by(*columns, rich_text: [])
      rich_text = Array(rich_text)

      rich_text.each do |name|
        define_method("plain_#{name}") { public_send(name).to_plain_text }
      end

      multisearchable against: columns + rich_text.map { |name| :"plain_#{name}" }
      pg_search_scope :search_text,
                      against: columns,
                      associated_against: rich_text.to_h { |name| [:"rich_text_#{name}", :body] },
                      using: { tsearch: { prefix: true, any_word: true } }
    end
  end

  included do
    include PgSearch::Model
  end
end
