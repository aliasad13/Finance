class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])
    stream_for conversation
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    conversation = Conversation.find(data["conversation_id"])
    message = conversation.messages.create!(content: data["content"], user: current_user)
    broadcast_message(conversation, message)
  end

  private

  def broadcast_message(conversation, message)
    ChatChannel.broadcast_to(conversation, {
      content: message.content,
      current_user_id: current_user.id,
      user: {
        id: message.user.id,
        username: message.user.username
      }
    })
  end
end
