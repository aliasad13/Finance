import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const conversationElement = document.getElementById('conversation-id')
    console.log('conversationElement: ', conversationElement)

  if (!conversationElement) return;

  const conversationId = conversationElement.getAttribute('data-conversation-id')

  if (conversationId) {
    const chatChannel = consumer.subscriptions.create(
        { channel: "ChatChannel", conversation_id: conversationId },
        {
          received(data) {
            console.log('Received data:', data)
            const messagesContainer = document.getElementById('messages')
              const messageHTML = `
            <div class="chat ${data.current_user === data.message.user_id ? 'chat-start' : 'chat-end'}"  data-user-id="${data.message_user}">
              <div class="chat-bubble"><p>${data.message.content}</p></div>
            </div>
          `;
            messagesContainer.insertAdjacentHTML('beforeend', messageHTML)
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
