class Message < ApplicationRecord

  after_create_commit { broadcast_message }

  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  def broadcast_message
    # ActionCable.server.broadcast "chat_#{conversation_id}_channel", {
    #   message: self,
    #   user: user
    # }
  end

end
