# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user, optional: true # отключаем валидацию которую создает belongs_to

  has_one_attached :img

  validates :name, :img, presence: true
end
