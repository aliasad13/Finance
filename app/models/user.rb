class User < ApplicationRecord

  has_many :user_movies
  has_many :movies, through: :user_movies
  has_one_attached :profile_picture
  has_many :friendships
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy  #if the user accepts the request a is friend to b and b is friend to a, if we dont use this the only b is friend to a(user_id an friend id in table)
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id', dependent: :destroy #user.sent_friend_requests => select * from friend requests where sender_id = user_id, this is the reason why we are using sender_id as foreign key
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id', dependent: :destroy #user.received_friend_requests, in the query we use where receiver_id = user.id

  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id'
  has_many :messages

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, presence: true, uniqueness: true

  after_create -> (user){ user.update(theme: 'dark') }
  after_create :send_welcome_email

  fullname = -> { firstname + " " + lastname }; define_method :fullname, &fullname
  # Yes, exactly! In Ruby, define_method is a method provided by the Module class,
  # which allows you to dynamically define instance methods. When you have a Proc or a lambda (-> { ... }),
  # you can use define_method to convert it into a method that can be called on instances of the class.

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



  def send_friend_request(user)
    sent_friend_requests.create(receiver: user, status: 'pending') unless friends?(user) || pending_friend_request?(user)
  end

  def accept_friend_request(user)
    request = received_friend_requests.find_by(sender: user, status: 'pending')
    if request
      request.update(status: 'accepted')
      friends << user; user.friends << self
    end
  end

  def sent_friend_request_to?(other_user)
    FriendRequest.exists?(sender_id: self.id, receiver_id: other_user.id)
  end

  def received_friend_request_from?(other_user)
    FriendRequest.exists?(sender_id: other_user.id, receiver_id: self.id)
  end

  def remove_friend_request(receiver)
    request = FriendRequest.find_by(sender: self, receiver: receiver, status: 'pending')
    request.destroy if request
  end

  def reject_friend_request(user)
    request = received_friend_requests.find_by(sender: user, status: 'pending')
    request.update(status: 'rejected') if request
  end

  def pending_friend_request?(user)
    sent_friend_requests.exists?(receiver: user, status: 'pending') || received_friend_requests.exists?(sender: user, status: 'pending')
  end

  def add_friend(friend)
    friendships.create(friend_id: friend.id)
  end

  def remove_friend(friend)
    friendship = friendships.find_by(friend_id: friend.id)
    friendship.destroy if friendship
  end

  def friends?(user)
    friends.include?(user) or user.friends.include?(self)
  end

  def profile_thumbnail
    if profile_picture.attached?
      profile_picture.variant(resize_to_fill: [200, 200]).processed
    else
      '/Avatar2.jpeg'
    end
  end

  private

  def send_welcome_email
    WelcomeMailSideKiqWorker.perform_async('welcome_email', self.id)
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
