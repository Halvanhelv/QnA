# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        redirect_to root_path, alert: exception.message
      end
      format.json do
        render json: { error: exception.message }, status: 422
      end
      format.js do
        render json: { error: exception.message }, status: 422
      end
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
