# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[github telegram]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes, dependent: :destroy
  has_many :oauth_providers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_oauth_provider(auth)
    oauth_providers.create(provider: auth['provider'], uid: auth['uid']) if persisted?
  end
end
