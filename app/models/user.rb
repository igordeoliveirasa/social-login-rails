class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter, :linkedin] 

  def self.find_or_create_user(provider, uid, name, email)
    user = nil
    if provider == "google_oauth2"
      user = User.where(:email => email).first
    else
      user = User.where(:provider => provider, :uid => uid).first
    end
    unless user
      user = User.create(name:name, provider:provider, uid:uid, email:email, password:Devise.friendly_token[0,20],)
    end
  end

  def self.from_omniauth(auth)
    user = self.find_or_create_user(auth.provider, auth.uid, auth.info.name, auth.info.email)
  end

  def self.find_for_google_oauth2(auth, signed_in_resource=nil)
    user = self.find_or_create_user(auth.provider, auth.uid, auth.info.name, auth.info.email)
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    email = nil
    if auth.uid
      email = auth.uid + "@twitter.com"
    end
    user = self.find_or_create_user(auth.provider, auth.uid, auth.extra.raw_info.name, email)
  end

  def self.connect_to_linkedin(auth, signed_in_resource=nil)
    user = self.find_or_create_user(auth.provider, auth.uid, auth.info.first_name, auth.info.email)
  end   

end
