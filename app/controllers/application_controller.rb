# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash', locals: { flash: { alert: exception.message } }),
               status: :forbidden
      end
      format.json { render json: { error: exception.message }, status: :unprocessable_entity }
    end
  end

  check_authorization unless: :devise_controller?
end
