# frozen_string_literal: true

# Keeps a record in the search index (SearchDocument).
#
#   searchable title: :title, body: :plain_body, tags: :tag_list
#
# Each value is a method name; missing values stay empty. Rich text goes through `Searchable.plain_text`
# so markup never matches and blocks never glue words together.
module Searchable
  extend ActiveSupport::Concern

  # Plain text of rich content with a space between blocks ("<h2>Steps</h2><p>Run" -> "Steps Run")
  def self.plain_text(rich_text)
    fragment = Nokogiri::HTML5.fragment(rich_text.to_s)
    fragment.css('h1,h2,h3,h4,h5,h6,p,div,li,pre,blockquote,tr,br').each { |node| node.add_next_sibling(' ') }
    fragment.text.squish
  end

  included do
    has_one :search_document, as: :searchable, dependent: :delete

    after_commit :index_for_search, on: %i[create update]
  end

  class_methods do
    def searchable(title: nil, body: nil, tags: nil)
      define_method(:search_document_attributes) do
        { title: title && send(title), body: body && send(body), tags: tags && send(tags) }.transform_values(&:to_s)
      end
    end
  end

  # Text of the body for previews, excerpts and the index
  def plain_body
    body.respond_to?(:to_plain_text) ? Searchable.plain_text(body) : body.to_s
  end

  private

  def index_for_search
    SearchDocument.reindex(self)
  end
end
