package com.example.agu_chat.model

data class Message(
    val id: Int,
    val senderId: String,
    val senderUsername: String,
    val senderPhotoUrl: String,
    val senderDisplayName: String,
    val recipientUsername: String,
    val recipientDisplayName: String,
    val recipientPhotoUrl: String,
    val content: String,
    val messageSent: String
) {

    val isIncoming: Boolean
        get() = senderUsername != Constanst.currentUsername
}