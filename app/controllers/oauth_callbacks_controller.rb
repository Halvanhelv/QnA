class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :session_data, only: [:github, :telegram]
  def github
    oauth_providers(session['omniauth.auth'])
  end
  def telegram
    oauth_providers(session['omniauth.auth'])
  end
  # def github
  #   render json: request.env['omniauth.auth']
  # end

  def custom_email
    # get_email if params[:email].blank?
    session['omniauth.auth']['info']['mail_from_user'] = params[:email]
    oauth_providers(session['omniauth.auth'])

  end

  private

  def oauth_providers(request)
    @user = User.find_for_oauth(request)
    if @user&.persisted? && @user&.confirmed_at?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message!(:notice, :success, kind: 'Github') if is_navigational_format?


    elsif @user&.persisted? && !@user&.confirmed_at?
      flash[:alert] = t('devise.failure.unconfirmed')
      redirect_to new_user_session_path

    elsif request
      render 'confirmations/email', locals: { resource: session['omniauth.auth']['provider'], user: @user }
    else
      redirect_to root_path
    end

  end

  def session_data
    session['omniauth.auth'] = request.env['omniauth.auth']
  end
end
