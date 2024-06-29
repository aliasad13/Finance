import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', () => {
  const conversationElement = document.getElementById('conversation-id')
    console.log('conversationElement: ', conversationElement)

  if (!conversationElement) return;

  const conversationId = conversationElement.getAttribute('data-conversation-id')

  if (conversationId) {
    const chatChannel = consumer.subscriptions.create(
        { channel: "ChatChannel", conversation_id: conversationId },
        {
          received(data) {
            console.log('data.message_user == data.current_user', data.message_user == data.current_user)
              if (data.message_user == data.current_user){

            const messagesContainer = document.getElementById('messages')
            const messageHTML = `
            <div class="chat chat-start"><div class="chat-bubble"><p>${data.message.content}</p></div></div>
          `;
            messagesContainer.insertAdjacentHTML('beforeend', messageHTML)
              }else{
                  const messagesContainer = document.getElementById('messages')
                  const messageHTML = `
            <div class="chat chat-end"><div class="chat-bubble"><p>${data.message.content}</p></div></div>
          `;
                  messagesContainer.insertAdjacentHTML('beforeend', messageHTML)

              }
          },
          speak: function(content) {
            return this.perform('receive', { conversation_id: conversationId, content: content })
          }
        }
    )

    const messageForm = document.getElementById('new_message')
    messageForm.addEventListener('submit', function(event) {
      event.preventDefault()
      const messageContent = event.target.querySelector('#message_content').value
      chatChannel.speak(messageContent)
      event.target.reset()
    })
  }
})
