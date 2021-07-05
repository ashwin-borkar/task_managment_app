class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  # devise :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :tasks

  # def self.from_omniauth(access_token)
  #   data = access_token.info
  #   user = User.where(:email => data["email"]).first

  #   unless user
  #     user = User.create(
  #           name: data["name"],
  #           email: data["email"],
  #           encrypted_password: Devise.friendly_token[0,20]
  #     )
  #   end
  #   user
  # end

  # def self.from_omniauth(access_token)
  #   data = access_token.info
  #   user = User.where(:email => data["email"]).first

  #   unless user
  #     user = User.create(
  #           name: data["name"],
  #           email: data["email"],
  #           encrypted_password: Devise.friendly_token[0,20]
  #     )
  #   end
  #   user
  # end
  # def self.from_google(email:, name:, access_token:, refresh_token:)
  #   return nil unless email =~ /@mybusiness.com\z/
  #   create_with(access_token: access_token, name: name, refresh_token: refresh_token).find_or_create_by!(email: email)
  # end

  # devise :omniauthable, :omniauth_providers => [:google_oauth2]
  # def self.from_omniauth(auth)
  #   # Either create a User record or update it based on the provider (Google) and the UID   
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.access_token = auth.credentials.access_token
  #     user.expires_at = auth.credentials.expires_at
  #     user.refresh_token = auth.credentials.refresh_token
  #   end
  # end
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  def self.find_for_google_oauth2(auth)
    data = auth.info
    if validate_email(auth)
      user = User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
      user.token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.save
      return user
    else
      return nil
    end
  end
end
