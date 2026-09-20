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

  # Plain text of rich content with a space between blocks ("<h2>Steps</h2><p>Run" -> "Steps Run"),
  # so excerpts and the search index never glue words together.
  def self.plain_text(rich_text)
    fragment = Nokogiri::HTML5.fragment(rich_text.to_s)
    fragment.css('h1,h2,h3,h4,h5,h6,p,div,li,pre,blockquote,tr,br').each { |node| node.add_next_sibling(' ') }
    fragment.text.squish
  end

  class_methods do
    def searchable_by(*columns, rich_text: [])
      rich_text = Array(rich_text)

      rich_text.each do |name|
        define_method("plain_#{name}") { Searchable.plain_text(public_send(name)) }
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
