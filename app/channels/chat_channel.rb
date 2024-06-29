class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])
    puts "\n\n\n\n\n\n\n\n\n\n #{conversation.inspect} \n\n\n\n\n\n\n\n\n\n\n"

    stream_for conversation
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    puts "\n\n\n\n\n\n\n\n\n\n #{data.inspect} \n\n\n\n\n\n\n\n\n\n\n"
    conversation = Conversation.find(data["conversation_id"])
    message = conversation.messages.create!(content: data["content"], user: current_user)
    broadcast_message(conversation, message)
  end

  private

  def broadcast_message(conversation, message)
    puts "\n\n\n\n\n\n\n\n\n\n #{conversation.inspect} \n\n\n\n\n\n\n\n\n\n\n"

    ChatChannel.broadcast_to(conversation, {
      content: message.content,
      user: {
        id: message.user.id,
        username: message.user.username
      }
    })
  end
end
