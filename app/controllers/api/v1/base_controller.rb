# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :doorkeeper_authorize!
      check_authorization

      rescue_from CanCan::AccessDenied do |exception|
        respond_to do |format|
          format.json do
            render json: { error: exception.message }, status: 403
          end
        end
      end

      protected

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def current_ability
        @ability ||= Ability.new(current_resource_owner)
      end
    end
  end
end
