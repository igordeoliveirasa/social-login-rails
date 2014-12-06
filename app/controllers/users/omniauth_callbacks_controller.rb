class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  attr_accessor :session_keys

  @session_keys = {"facebook" => "devise.facebook_data", "google_oauth2" => "devise.google_data",
                    "twitter" => "devise.twitter_uid", "linkedin" => "devise.linkedin_uid"}

  def protocol_omniauth(auth)

    ret = {"provider" => auth.provider, "uid" => auth.uid, "name" => nil, "email" => nil}

    if ["facebook", "google_oauth2", "github"].include?(auth.provider)
      ret['name'] = auth.info.name
      ret['email'] = auth.info.email
    elsif auth.provider == "twitter"
      ret['name'] = auth.extra.raw_info.name
      ret['email'] = auth.uid + "@twitter.com" if auth.uid
    elsif auth.provider == "linkedin"
      ret['name'] = auth.info.first_name
      ret['email'] = auth.info.email
    end

    ret
  end

  def authenticate(provider, uid, email)
    user = User.social_authentication(provider, uid, email)
    unless user
      user = User.social_registration(provider, uid, email)
    end

    if user.persisted?
      sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
    else
      session_key = :session_keys[provider]
      session[session_key] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def facebook
    # convert to the same protocol
    auth = protocol_omniauth(request.env["omniauth.auth"])
    authenticate auth["provider"], auth["uid"], auth["email"]
  end

  def google_oauth2
    # convert to the same protocol
    auth = protocol_omniauth(request.env["omniauth.auth"])
    authenticate auth["provider"], auth["uid"], auth["email"]
  end

  def twitter
    # convert to the same protocol
    auth = protocol_omniauth(request.env["omniauth.auth"])
    authenticate auth["provider"], auth["uid"], auth["email"]
  end

  def linkedin
    # convert to the same protocol
    auth = protocol_omniauth(request.env["omniauth.auth"])
    authenticate auth["provider"], auth["uid"], auth["email"]
  end

  def github
    # convert to the same protocol
    auth = protocol_omniauth(request.env["omniauth.auth"])
    authenticate auth["provider"], auth["uid"], auth["email"]
  end

end

