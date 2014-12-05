class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  attr_accessor :session_keys

  @session_keys = {"facebook" => "devise.facebook_data", "google_oauth2" => "devise.google_data",
                    "twitter" => "devise.twitter_uid", "linkedin" => "devise.linkedin_uid"}

  def convert_omniauth_to_auth(auth)

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

  def create_user_with_auth(auth)
    user = User.create(provider:auth["provider"], uid:auth["uid"], name:auth["name"], email:auth["email"], password:Devise.friendly_token[0,20],)
    Uid.create(provider:auth["provider"], uid:auth["uid"], user:user)
    user
  end

  def authenticate
    auth = convert_omniauth_to_auth(request.env["omniauth.auth"])

    # search
    user = User.find_by_uid(auth["uid"])

    unless user
      user = User.find_by_email(auth["email"])

      if user
        # creating uid as it doesnt exist yet
        Uid.create(provider:auth["provider"], uid:auth["uid"], user:user)
      end

    end


    # creating user if nil
    unless user
      user = create_user_with_auth(auth)
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

