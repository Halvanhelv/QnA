class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github')
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
  # def github
  #   render json: request.env['omniauth.auth']
  # end
end
