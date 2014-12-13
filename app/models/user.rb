class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter, :linkedin, :github]

  has_many :uids

  def self.find_by_email(email)
    User.where(:email => email).first
  end

  def self.find_by_uid(uid)
    User.joins(:uids).where(uids:{uid:uid}).first
  end


  def self.social_authentication(user_to_be_auth)
    user = find_by_uid(user_to_be_auth.uid)

    # there isn't uid registered, check email
    unless user
      if user_to_be_auth.email
        user = find_by_email(user_to_be_auth.email)
        if user
          uid = Uid.create(provider: user_to_be_auth.provider, uid:user_to_be_auth.uid, user:user)
          user.uids << uid
        end
      end
    end
    user
  end

  def self.social_registration(user_to_be_reg)
    user = User.create(provider: user_to_be_reg.provider, uid:user_to_be_reg.uid, email:user_to_be_reg.email, password:Devise.friendly_token[0,20],
    name:user_to_be_reg.name)
    Uid.create(provider: user_to_be_reg.provider, uid:user_to_be_reg.uid, user:user)
    user
  end



end
