class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  attr_accessor :session_keys

  @session_keys = {"facebook" => "devise.facebook_data", "google_oauth2" => "devise.google_data",
                    "twitter" => "devise.twitter_uid", "linkedin" => "devise.linkedin_uid"}

  def omniauth_to_user(auth)

    #ret = {"provider" => auth.provider, "uid" => auth.uid, "name" => nil, "email" => nil, "image" => nil}
    user = User.new(provider: auth.provider, uid: auth.uid)

    if ["facebook", "google_oauth2", "github"].include?(auth.provider)
      user.name = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
    elsif auth.provider == "twitter"
      user.name = auth.info.name
      user.email = auth.uid + "@twitter.com" if auth.uid
      user.image = auth.info.image
    elsif auth.provider == "linkedin"
      name = ""

      if auth.info
        if auth.info.first_name
          name = auth.info.first_name
          if auth.info.last_name
            name += " " + auth.info.last_name
          end
        end
      end

      name = name.strip
      user.name = name
      user.email = auth.info.email
      user.image = auth.info.image
    end

    user
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

