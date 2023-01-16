package com.example.agu_chat.data

import com.example.agu_chat.model.Constanst
import com.example.agu_chat.model.CreateMessage
import com.example.agu_chat.model.Message
import com.google.gson.reflect.TypeToken
import com.microsoft.signalr.Action1
import com.microsoft.signalr.HubConnection
import com.microsoft.signalr.HubConnectionBuilder
import com.microsoft.signalr.HubConnectionState
import io.reactivex.rxjava3.core.Single


typealias ChatThreadListener = (ArrayList<Message>) -> Unit

class MessageHub {
    private var _messages: ArrayList<Message> = ArrayList()
    private val listeners = mutableListOf<ChatThreadListener>()

    private var hubConnection: HubConnection? = null

    val messages: ArrayList<Message> get() = _messages

    companion object {
        var token = ""
    }

    fun createHubConnection(otherUserName: String){
        if(hubConnection == null){
            hubConnection = HubConnectionBuilder.create("${Constanst.HUB_URL}message?user=$otherUserName")
                .withAccessTokenProvider(Single.defer { Single.just("$token") })
                .build()

            hubConnection?.on("ReceiveMessageThread",
                Action1 { listMessage ->
                    val json = Constanst.arrayToString(listMessage);
                    val type = object : TypeToken<List<Message>>() {}.type
                    val result: List<Message> = Constanst.parseArray(json.toString(),type)
                    _messages.addAll(result)
                    listeners.forEach { listener -> listener(_messages) }
                },
                List::class.java
            )

            hubConnection?.on("NewMessage",
                Action1 { message ->
                    _messages.add(message)
                    listeners.forEach { listener -> listener(_messages) }
                },
                Message::class.java
            )

            hubConnection!!.start().blockingAwait()
        }
    }

    fun stopHubConnection(){
        if(hubConnection?.connectionState == HubConnectionState.CONNECTED){
            hubConnection!!.stop()
            hubConnection = null
        }
    }

    fun sendMessage(createMessage: CreateMessage){
        hubConnection?.send("SendMessage", createMessage)
    }

    fun addListener(listener: ChatThreadListener) {
        listeners.add(listener)
    }

    fun removeListener(listener: ChatThreadListener) {
        listeners.remove(listener)
    }
}