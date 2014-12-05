class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter, :linkedin, :github]

  def self.find(provider, uid, name, email)
    user = User.where(:email => email).first

    unless user
      user = User.where(:provider => provider, :uid => uid).first
    end

    user
  end

  def self.find_by_uid(uid)
    #Uid.where(:)
  end


end
