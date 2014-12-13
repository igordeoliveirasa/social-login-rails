class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  attr_accessor :session_keys

  @session_keys = {"facebook" => "devise.facebook_data", "google_oauth2" => "devise.google_data",
                    "twitter" => "devise.twitter_uid", "linkedin" => "devise.linkedin_uid"}


  def get_oauth_email(auth)
    if auth.provider == "twitter"
      auth.uid + "@twitter.com" if auth.uid
    else
      auth.info.email
    end
  end

  def get_oauth_name(auth)
    if auth.provider == "linkedin"
      (auth.info.first_name + " " + auth.info.last_name).strip
    else
      auth.info.name
    end
  end

  def omniauth_to_user(auth)
    user = User.new(
        provider: auth.provider,
        uid: auth.uid,
        name: get_oauth_name(auth),
        email: get_oauth_email(auth),
        image:auth.info.image)
  end

  def authenticate(user_to_be_auth)
    user = User.social_authentication(user_to_be_auth)
    unless user
      user = User.social_registration(user_to_be_auth)
    end

    if user and user.persisted?
      sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => user.provider) if is_navigational_format?
    else
      session_key = :session_keys[user_to_be_auth.provider]
      session[session_key] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def treat_omniauth
    # convert to the same protocol
    user = omniauth_to_user(request.env["omniauth.auth"])
  end

  def treat_omniauth_and_authenticate
    user = treat_omniauth
    authenticate user
  end

  def facebook
    treat_omniauth_and_authenticate
  end

  def google_oauth2
    treat_omniauth_and_authenticate
  end

  def twitter
    treat_omniauth_and_authenticate
  end

  def linkedin
    treat_omniauth_and_authenticate
  end

  def github
    treat_omniauth_and_authenticate
  end

end

