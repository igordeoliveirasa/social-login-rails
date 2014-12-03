class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def find_or_create_user(auth)
    @session_key = ""
    @user = nil

    if auth.provider == "facebook"
      @session_key = "devise.facebook_data"
      @user = User.find_or_create_user(auth.provider, auth.uid, auth.info.name, auth.info.email )
    elsif auth.provider == "google_oauth2"
      @session_key = "devise.google_data"
      @user = User.find_or_create_user(auth.provider, auth.uid, auth.info.name, auth.info.email )
    elsif auth.provider == "twitter"
      @session_key = "devise.twitter_uid"
      email = nil
      if auth.uid
        email = auth.uid + "@twitter.com"
      end
      @user = User.find_or_create_user(auth.provider, auth.uid, auth.extra.raw_info.name, email)
    elsif auth.provider == "linkedin"
      @session_key = "devise.linkedin_uid"
      @user = User.find_or_create_user(auth.provider, auth.uid, auth.info.first_name, auth.info.email)
    end
  end

  def authenticate
    auth = request.env["omniauth.auth"]
    find_or_create_user(auth)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => auth.provider) if is_navigational_format?
    else
      session[@session_key] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def facebook
    authenticate
  end

  def google_oauth2
    authenticate
  end

  def twitter
    authenticate
  end

  def linkedin
    authenticate
  end

end

