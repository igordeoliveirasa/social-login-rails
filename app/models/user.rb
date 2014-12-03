class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter, :linkedin, :github]

  def self.find_or_create_user(provider, uid, name, email)
    user = nil
    if ["google_oauth2", "linkedin"].include?(provider)
      user = User.where(:email => email).first
    else
      user = User.where(:provider => provider, :uid => uid).first
    end
    unless user
      user = User.create(name:name, provider:provider, uid:uid, email:email, password:Devise.friendly_token[0,20],)
    end
    user
  end

end
