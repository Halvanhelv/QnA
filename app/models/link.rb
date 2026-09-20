# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI::DEFAULT_PARSER.make_regexp

  def gist?
    URI.parse(url).host.include?('gist')
  end

  def get_gist
    client = Octokit::Client.new
    gist_id = URI.parse(url).path.split('/').last
    client.gist(gist_id)
  end

  # Gist files for display; a GitHub outage must not break page rendering.
  def gist_files
    Rails.cache.fetch(['gist', url], expires_in: 1.hour) do
      get_gist.files.to_h.transform_values { |file| file[:content] }
    end
  rescue Octokit::Error, Faraday::Error
    {}
  end
end
