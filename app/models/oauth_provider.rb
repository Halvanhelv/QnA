# frozen_string_literal: true

class OauthProvider < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :provider, :uid, presence: true
end
