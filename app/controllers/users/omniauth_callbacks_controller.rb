class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def google_oauth2
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
  #   if @user.persisted?
  #     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
  #     auth = request.env["omniauth.auth"]
  #     @user.access_token = auth.credentials.token
  #     @user.expires_at = auth.credentials.expires_at
  #     @user.refresh_token = auth.credentials.refresh_token
  #     @user.save!
  #     sign_in(@user)
  #     redirect_to tasks_path
  #   else
  #     session["devise.google_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

   def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"])
    if @user
      sign_in @user
      redirect_to root_path
    else
      redirect_to new_user_session_path, notice: 'Access Denied.'
    end
  end
  #  def google_oauth2
  #   admin = Admin.from_google(from_google_params)

  #   if admin.present?
  #     sign_out_all_scopes
  #     flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
  #     sign_in_and_redirect admin, event: :authentication
  #   else
  #     flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
  #     redirect_to new_admin_session_path
  #   end
  # end

  # protected

  # def after_omniauth_failure_path_for(_scope)
  #   new_admin_session_path
  # end

  # def after_sign_in_path_for(resource_or_scope)
  #   stored_location_for(resource_or_scope) || root_path
  # end

  # private

  # def from_google_params
  #   @from_google_params ||= {
  #     uid: auth.uid,
  #     email: auth.info.email,
  #     full_name: auth.info.name,
  #     avatar_url: auth.info.image
  #   }
  # end

  # def auth
  #   @auth ||= request.env['omniauth.auth']
  # end

  # def google_oauth2
  #   user = User.from_google(from_google_params)

  #   if user.present?
  #     sign_out_all_scopes
  #     flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
  #     sign_in_and_redirect user, event: :authentication
  #   else
  #     flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
  #     redirect_to new_user_session_path
  #   end
  # end

  # def google_oauth2
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
  #   if @user.persisted?
  #     sign_in @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
  #   else
  #     session["devise.google_data"] = request.env["omniauth.auth"]
  #   end
  #   redirect_to '/'
  # end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def from_google_params
    @from_google_params ||= {
      access_token: auth.access_token,
      email: auth.info.email,
      name: auth.info.name,
      refresh_token: auth.info.refresh_token
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end