class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  attr_accessor :session_keys

  @session_keys = {"facebook" => "devise.facebook_data", "google_oauth2" => "devise.google_data",
                    "twitter" => "devise.twitter_uid", "linkedin" => "devise.linkedin_uid"}

  def get_login_attributes(auth)

    name = nil
    email = nil

    if ["facebook", "google_oauth2", "github"].include?(auth.provider)
      name = auth.info.name
      email = auth.info.email
    elsif auth.provider == "twitter"
      name = auth.extra.raw_info.name
      email = nil
      if auth.uid
        email = auth.uid + "@twitter.com"
      end
    elsif auth.provider == "linkedin"
      name = auth.info.first_name
      email = auth.info.email
    end

    { "provider" => auth.provider, "uid" => auth.uid, "name"=>name, "email" => email }

  end


  def authenticate
    auth = request.env["omniauth.auth"]
    login_attributes = get_login_attributes(auth)

    # search
    @user = User.find(login_attributes["provider"], login_attributes["uid"], login_attributes["name"], login_attributes["email"] )

    # creating user if nil
    unless @user
      @user = User.create(provider:login_attributes["provider"], uid:login_attributes["uid"], name:login_attributes["name"], email:login_attributes["email"], password:Devise.friendly_token[0,20],)
    end

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => auth.provider) if is_navigational_format?
    else
      session_key = :session_keys[auth.provider]
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

