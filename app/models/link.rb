class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI::regexp

  def gist?
    URI.parse(url).host.include?('gist')
  end

  def get_gist
    client = Octokit::Client.new # Ввести свои данные что бы гит давал приоритет для запросов
    gist_id = URI.parse(url).path.split('/').last
    client.gist(gist_id)
  end
end
