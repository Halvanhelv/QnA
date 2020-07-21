class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true # отключаем валидацию которую создает belongs_to

  has_one_attached :img

  validates :name, :img, presence: true
end
