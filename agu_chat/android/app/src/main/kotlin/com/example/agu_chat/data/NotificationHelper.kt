package com.example.agu_chat.data

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.annotation.WorkerThread
import androidx.core.app.NotificationCompat
import androidx.core.app.Person
//import androidx.core.app.RemoteInput
import androidx.core.content.LocusIdCompat
import androidx.core.content.getSystemService
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import androidx.core.net.toUri
import com.example.agu_chat.*
import com.example.agu_chat.model.Constanst
import com.example.agu_chat.model.Member
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL
import java.util.*

/**
 * Handles all operations related to [Notification].
 */
class NotificationHelper(private val context: Context) {

    companion object {
        /**
         * The notification channel for messages. This is used for showing Bubbles.
         */
        private const val CHANNEL_NEW_MESSAGES = "new_messages"

        private const val REQUEST_CONTENT = 1
        private const val REQUEST_BUBBLE = 2
    }

    private val notificationManager: NotificationManager =
        context.getSystemService() ?: throw IllegalStateException()


    fun setUpNotificationChannels() {
        if (notificationManager.getNotificationChannel(CHANNEL_NEW_MESSAGES) == null) {
            notificationManager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_NEW_MESSAGES,
                    context.getString(R.string.channel_new_messages),
                    // The importance must be IMPORTANCE_HIGH to show Bubbles.
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = context.getString(R.string.channel_new_messages_description)
                }
            )
        }
        updateShortcuts(null, Constanst.contacts)
    }

    //trang tri notification
    @WorkerThread
    fun updateShortcuts(importantContact: Member?, memberOnline: List<Member>) {
        var shortcuts = memberOnline.map { contact ->
            val icon = getImageForUser(contact)?.let {
                IconCompat.createWithAdaptiveBitmap(
                    it
                )
            }
            // Create a dynamic shortcut for each of the contacts.
            // The same shortcut ID will be used when we show a bubble notification.
            ShortcutInfoCompat.Builder(context, "contact_${contact.userName}")
                .setLocusId(LocusIdCompat("contact_${contact.userName}"))
                .setActivity(ComponentName(context, MainActivity::class.java))
                .setShortLabel(contact.userName)
                .setIcon(icon)
                .setLongLived(true)
                .setCategories(setOf("com.example.android.bubbles.category.TEXT_SHARE_TARGET"))
                .setIntent(
                    Intent(context, MainActivity::class.java)
                        .setAction(Intent.ACTION_VIEW)
                        .setData(
                            Uri.parse(
                                "https://android.example.com/chat/${contact.userName}"
                            )
                        )
                )
                .setPerson(
                    Person.Builder()
                        .setName(contact.userName)
                        .setIcon(icon)
                        .build()
                )
                .build()
        }
        // Move the important contact to the front of the shortcut list.
        if (importantContact != null) {
            shortcuts = shortcuts.sortedByDescending { it.id == importantContact.userName }
        }
        // Truncate the list if we can't show all of our contacts.
        val maxCount = ShortcutManagerCompat.getMaxShortcutCountPerActivity(context)
        if (shortcuts.size > maxCount) {
            shortcuts = shortcuts.take(maxCount)
        }
        for (shortcut in shortcuts) {
            ShortcutManagerCompat.pushDynamicShortcut(context, shortcut)
        }
    }

    //
    private fun getImageForUser(contact: Member): Bitmap? {
        var bitmapImgFromUrl: Bitmap? = null
        // neu imageUrl != null thi tao imageUrl thanh bimap
        bitmapImgFromUrl = if(contact.imageUrl != null){
            getBitmapFromUrl(contact.imageUrl)
        }else{
            // neu imageUrl null thi lay anh mac dinh "cat.jpg"
            context.resources.assets.open("cat.jpg").use { input ->
                BitmapFactory.decodeStream(input)
            }
        }
        return bitmapImgFromUrl
    }

    // convert imagUrl thanh bimap
    private fun getBitmapFromUrl(urlString: String): Bitmap? {
        var bitmap: Bitmap? = null
        var inputStream: InputStream? = null
        var urlConnection: HttpURLConnection? = null

        try {
            val url = URL(urlString)
            urlConnection = url.openConnection() as HttpURLConnection
            urlConnection.doInput = true
            urlConnection.connect()

            inputStream = urlConnection.inputStream
            bitmap = BitmapFactory.decodeStream(inputStream)
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            urlConnection?.disconnect()
            inputStream?.close()
        }

        return bitmap
    }

    private fun flagUpdateCurrent(mutable: Boolean): Int {
        return if (mutable) {
            if (Build.VERSION.SDK_INT >= 31) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        }
    }

    @WorkerThread
    fun showNotification(mesageContent: String,
                         memberOnline:List<Member>,
                         chat: Member,
                         fromUser: Boolean,
                         update: Boolean = false) {
        updateShortcuts(chat, memberOnline)
        val iconUri = "content://com.example.android.people/icon/${chat.userName}".toUri()
        val icon = IconCompat.createWithAdaptiveBitmapContentUri(iconUri)
        val user = Person.Builder().setName(context.getString(R.string.sender_you)).build()
        val person = Person.Builder().setName(chat.userName).setIcon(icon).build()
        val contentUri = "https://android.example.com/chat/${chat.userName}".toUri()

        val pendingIntent = PendingIntent.getActivity(
            context,
            REQUEST_BUBBLE,
            // Launch BubbleActivity as the expanded bubble.
            Intent(context, BubbleActivity::class.java)
                .setAction(Intent.ACTION_VIEW)
                .setData(contentUri),
            flagUpdateCurrent(mutable = true)
        )
        // Let's add some more content to the notification in case it falls back to a normal
        // notification.
        val messagingStyle = NotificationCompat.MessagingStyle(user)

        val m = NotificationCompat.MessagingStyle.Message(mesageContent, System.currentTimeMillis(), person)
        messagingStyle.addMessage(m)

        val builder = NotificationCompat.Builder(context, CHANNEL_NEW_MESSAGES)
            // A notification can be shown as a bubble by calling setBubbleMetadata()
            .setBubbleMetadata(
                NotificationCompat.BubbleMetadata.Builder(pendingIntent, icon)
                    // The height of the expanded bubble.
                    .setDesiredHeight(context.resources.getDimensionPixelSize(R.dimen.bubble_height))
                    .apply {
                        // When the bubble is explicitly opened by the user, we can show the bubble
                        // automatically in the expanded state. This works only when the app is in
                        // the foreground.
                        if (fromUser) {
                            setAutoExpandBubble(false)
                        }
                        if (fromUser || update) {
                            setSuppressNotification(false)
                        }
                    }
                    .build()
            )
            // The user can turn off the bubble in system settings. In that case, this notification
            // is shown as a normal notification instead of a bubble. Make sure that this
            // notification works as a normal notification as well.
            .setContentTitle(chat.userName)
            .setSmallIcon(R.drawable.ic_message)
            .setCategory(Notification.CATEGORY_MESSAGE)
            .setShortcutId("contact_${chat.userName}")//val shortcutId = "contact_$id"
            // This ID helps the intelligence services of the device to correlate this notification
            // with the corresponding dynamic shortcut.
            .setLocusId(LocusIdCompat("contact_${chat.userName}"))
            .addPerson(person)
            .setShowWhen(true)
            // The content Intent is used when the user clicks on the "Open Content" icon button on
            // the expanded bubble, as well as when the fall-back notification is clicked.
            .setContentIntent(
                PendingIntent.getActivity(
                    context,
                    REQUEST_CONTENT,
                    Intent(context, MainActivity::class.java)
                        .setAction(Intent.ACTION_VIEW)
                        .setData(contentUri),
                    flagUpdateCurrent(mutable = false)
                )
            )
            // Direct Reply
            /*.addAction(
                NotificationCompat.Action
                    .Builder(
                        IconCompat.createWithResource(context, R.drawable.ic_send),
                        context.getString(R.string.label_reply),
                        PendingIntent.getBroadcast(
                            context,
                            REQUEST_CONTENT,
                            Intent(context, ReplyReceiver::class.java).setData(contentUri),
                            flagUpdateCurrent(mutable = true)
                        )
                    )
                    .addRemoteInput(
                        RemoteInput.Builder(ReplyReceiver.KEY_TEXT_REPLY)
                            .setLabel(context.getString(R.string.hint_input))
                            .build()
                    )
                    .setAllowGeneratedReplies(true)
                    .build()
            )*/
            // Let's add some more content to the notification in case it falls back to a normal
            // notification.
            .setStyle(messagingStyle)
            .setWhen(System.currentTimeMillis())
        // Don't sound/vibrate if an update to an existing notification.
        if (update) {
            builder.setOnlyAlertOnce(true)
        }
        val arrByte = chat.userName.toByteArray()
        notificationManager.notify(arrByte.sum(), builder.build())
    }

    private fun dismissNotification(id: String) {
        notificationManager.cancel(id.toByteArray().sum())
    }

    @RequiresApi(Build.VERSION_CODES.R)
    fun canBubble(contact: Member): Boolean {
        val channel = notificationManager.getNotificationChannel(
            CHANNEL_NEW_MESSAGES,
            "contact_${contact.userName}"
        )
        return notificationManager.areBubblesAllowed() || channel?.canBubble() == true
    }

    fun updateNotification(chat: String, prepopulatedMsgs: Boolean) {
        if (!prepopulatedMsgs) {
            // Update notification bubble metadata to suppress notification so that the unread
            // message badge icon on the collapsed bubble is removed.
            val memberTemp = Constanst.contacts.find { member -> member.userName == chat }
            if (memberTemp != null) {
                showNotification("",Constanst.contacts.toList(), memberTemp, fromUser = false, update = true)
            }
        } else {
            dismissNotification(chat)
        }
    }
}
