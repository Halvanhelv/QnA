# frozen_string_literal: true

class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :id, :created_at, :updated_at
end
