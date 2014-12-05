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


  def self.social_authentication(provider, uid, email)

    user = find_by_uid(uid)

    # there isn't uid registered, check email
    unless user
      if email
        user = find_by_email(email)
        if user
          uid = Uid.create(provider: provider, uid:uid, user:user)
          user.uids << uid
        end
      end
    end

    # there isn't uid neither email
    unless user
      user = User.create(provider: provider, uid:uid, email:email, password:Devise.friendly_token[0,20])
      Uid.create(provider: provider, uid:uid, user:user)
    end
    user
  end

end
