class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  attr_accessor :session_keys

  @session_keys = {"facebook" => "devise.facebook_data", "google_oauth2" => "devise.google_data",
                    "twitter" => "devise.twitter_uid", "linkedin" => "devise.linkedin_uid"}

  def get_login_attributes(auth)

    ret = {"provider" => auth.provider, "uid" => auth.uid}

    if ["facebook", "google_oauth2", "github"].include?(auth.provider)
      ret['name'] = auth.info.name
      ret['email'] = auth.info.email
    elsif auth.provider == "twitter"
      ret['name'] = auth.extra.raw_info.name
      ret['email'] = nil
      if auth.uid
        ret['email'] = auth.uid + "@twitter.com"
      end
    elsif auth.provider == "linkedin"
      ret['name'] = auth.info.first_name
      ret['email'] = auth.info.email
    end

    ret
  end


  def authenticate
    auth = get_login_attributes(request.env["omniauth.auth"])

    # search
    user = User.find(auth["provider"], auth["uid"], auth["name"], auth["email"] )

    # creating user if nil
    unless user
      user = User.create(provider:auth["provider"], uid:auth["uid"], name:auth["name"], email:auth["email"], password:Devise.friendly_token[0,20],)
    end

    if user.persisted?
      sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => auth['provider']) if is_navigational_format?
    else
      session_key = :session_keys[auth['provider']]
      session[session_key] = request.env["omniauth.auth"]
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

  def github
    authenticate
  end

end

