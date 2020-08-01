# frozen_string_literal: true

class ApplicationController < ActionController::Base

  before_action :gon_user

  private

  def gon_user
    gon.user_id = current_user&.id
  end

end
