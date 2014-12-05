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

end
