class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.create!(message_params.merge(user: current_user))
    puts "\n\n\n\n\n\n\n\n\n\n broadcast after creating message \n\n\n\n\n\n\n\n\n\n\n"
    puts "\n\n\n\n\n\n\n\n\n\n @conversation: #{@conversation.inspect},  @message: #{@message.inspect} \n\n\n\n\n\n\n\n\n\n\n"
    username = @message.user.fullname
    payload = {message: @message, current_user: current_user.id, message_user: @message.user_id}
    ChatChannel.broadcast_to(@conversation, payload)
    #this will broadcast to chat_channel.js where receive(data) will receive the data we send here. There it will be appended on the given element
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
