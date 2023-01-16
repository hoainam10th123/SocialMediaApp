package com.example.agu_chat

import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.commitNow
import com.example.agu_chat.model.Member

class BubbleActivity : AppCompatActivity(R.layout.activity_bubble), INavigationController {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val id = intent.data?.lastPathSegment.toString()

        if (savedInstanceState == null) {
            supportFragmentManager.commitNow {
                replace(R.id.container, ChatFragment.newInstance(id, false))
            }
        }
    }

    override fun openChat(id: Member, prepopulateText: String?) {
        throw UnsupportedOperationException("BubbleActivity always shows a single chat thread.")
    }

    override fun openPhoto(photo: Uri) {
        // In an expanded Bubble, you can navigate between Fragments just like you would normally
        // do in a normal Activity. Just make sure you don't block onBackPressed().
        /*supportFragmentManager.commit {
            addToBackStack(null)
            replace(R.id.container, PhotoFragment.newInstance(photo))
        }*/
    }

    override fun updateAppBar(
        showContact: Boolean,
        hidden: Boolean,
        body: (name: TextView, icon: ImageView) -> Unit
    ) {
        // The expanded bubble does not have an app bar. Ignore.
    }
}