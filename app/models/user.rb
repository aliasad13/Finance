class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, presence: true, uniqueness: true

  after_create -> (user){ user.update(theme: 'dark') }
  after_create :send_welcome_email

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      username = generate_unique_username(data['first_name'], data['last_name'])
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0, 20],
        firstname: data['first_name'],
        lastname: data['last_name'],
        username: username
      )
    end

    user
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome_email.deliver_now
  end

  def self.generate_unique_username(firstname, lastname)
    base_username = "#{firstname.downcase}_#{lastname.downcase}"
    username = base_username
    counter = 1

    while User.exists?(username: username)
      username = "#{base_username}_#{counter}"
      counter += 1
    end

    username
  end

end
