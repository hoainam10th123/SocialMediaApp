package com.example.agu_chat

import android.app.Application
import androidx.lifecycle.*
import com.example.agu_chat.data.DefaultChatRepository
import com.example.agu_chat.data.IChatRepository
import com.example.agu_chat.data.MessageHub
import com.example.agu_chat.model.CreateMessage
import com.example.agu_chat.model.Message


class ChatViewModel @JvmOverloads constructor(
    application: Application,
    private val repository: IChatRepository = DefaultChatRepository.getInstance(application)
) : AndroidViewModel(application) {
    private val chatId = MutableLiveData<String>()
    private var chatHub: MessageHub? = MessageHub()
    /**
     * We want to update the notification when the corresponding chat screen is open. Setting this
     * to `true` updates the current notification, removing the unread message(s) badge icon and
     * suppressing further notifications.
     *
     * We do want to keep on showing and updating the notification when the chat screen is opened
     * as an expanded bubble. [ChatFragment] should set this to false if it is launched in
     * BubbleActivity. Otherwise, the expanding a bubble would remove the notification and the
     * bubble.
     */
    var foreground = false
        set(value) {
            field = value
            chatId.value?.let { id ->
                if (value) {
                    //repository.activateChat(id)
                } else {
                    //repository.deactivateChat(id)
                }
            }
        }

    /**
     * The list of all the messages in this chat.
     */
    val messages = chatId.switchMap { id -> findMessages(id) }

    fun findMessages(username: String): LiveData<List<Message>> {
        return object : LiveData<List<Message>>() {

            private val listener = { messages: List<Message> ->
                postValue(messages)
            }

            override fun onActive() {
                value = chatHub?.messages
                chatHub?.addListener(listener)
            }

            override fun onInactive() {
                chatHub?.removeListener(listener)
            }
        }
    }

    /**
     * Whether the "Show as Bubble" button should be shown.
     */
    //val showAsBubbleVisible = chatId.map { id -> repository.canBubble(id) }

    fun setChatId(id: String) {
        chatId.value = id
        chatHub?.createHubConnection(id)
        if (foreground) {
            //repository.activateChat(id)
        } else {
            //repository.deactivateChat(id)
        }
    }

    fun send(recipientUsername: String, text: String) {
        chatHub?.sendMessage(CreateMessage(recipientUsername, text))
    }

    fun showAsBubble() {
        chatId.value?.let { id ->
            //repository.showAsBubble(id)
        }
    }

    /*fun setPhoto(uri: Uri, mimeType: String) {
        _photoUri.value = uri
        _photoMimeType = mimeType
    }*/

    override fun onCleared() {
        chatHub?.stopHubConnection()
        chatHub = null
    }
}