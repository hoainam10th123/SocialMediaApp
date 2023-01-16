package com.example.agu_chat

import android.os.Build
import android.os.Bundle
import android.view.*
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.agu_chat.*
import com.example.agu_chat.data.MessageAdapter
import com.example.agu_chat.databinding.FragmentChatBinding

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 * Use the [ChatFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class ChatFragment : Fragment(R.layout.fragment_chat) {

    companion object {
        private const val ARG_ID = "id"
        private const val ARG_FOREGROUND = "foreground"
        private const val ARG_PREPOPULATE_TEXT = "prepopulate_text"

        fun newInstance(id: String, foreground: Boolean, prepopulateText: String? = null) =
            ChatFragment().apply {
                arguments = Bundle().apply {
                    putString(ARG_ID, id)
                    putBoolean(ARG_FOREGROUND, foreground)
                    putString(ARG_PREPOPULATE_TEXT, prepopulateText)
                }
            }
    }

    private var currentUser: String? = null

    private val viewModel: ChatViewModel by viewModels()
    private val binding by viewBindings(FragmentChatBinding::bind)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //setHasOptionsMenu(true)
        //enterTransition = TransitionInflater.from(context).inflateTransition(R.transition.slide_bottom)
    }

    @RequiresApi(Build.VERSION_CODES.R)
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val id = arguments?.getString(ARG_ID)
        if (id == null) {
            parentFragmentManager.popBackStack()
            return
        }
        val prepopulateText = arguments?.getString(ARG_PREPOPULATE_TEXT)
        val navigationController = getNavigationController()

        currentUser = id
		activity?.title = id		
        viewModel.setChatId(id)

        val messageAdapter = MessageAdapter(view.context) { uri ->
            //navigationController.openPhoto(uri) // open photo tren chat bar
        }
        val linearLayoutManager = LinearLayoutManager(view.context).apply {
            stackFromEnd = true
        }
        binding.messages.run {
            layoutManager = linearLayoutManager
            adapter = messageAdapter
        }

        /*viewModel.contact.observe(viewLifecycleOwner) { contact ->
            if (contact == null) {
                Toast.makeText(view.context, "Contact not found", Toast.LENGTH_SHORT).show()
                parentFragmentManager.popBackStack()
                requireActivity().setLocusContext(null, null)
            } else {
                requireActivity().setLocusContext(LocusId(contact.userName), null)
                navigationController.updateAppBar { name, icon ->
                    name.text = contact.userName
                    icon.setImageIcon(Icon.createWithAdaptiveBitmapContentUri(contact.imageUrl))
                    startPostponedEnterTransition()
                }
            }
        }*/

        // lang nghe su kien messages add or remove
        viewModel.messages.observe(viewLifecycleOwner) { messages ->
            messageAdapter.submitList(messages)
            linearLayoutManager.scrollToPosition(messages.size - 1)
        }

        /*if (prepopulateText != null) {
            binding.input.setText(prepopulateText)
        }*/

        /*binding.input.setOnImageAddedListener { contentUri, mimeType, label ->
            //viewModel.setPhoto(contentUri, mimeType)
            if (binding.input.text.isNullOrBlank()) {
                binding.input.setText(label)
            }
        }*/

        /*viewModel.photo.observe(viewLifecycleOwner) { uri ->
            if (uri == null) {
                binding.photo.visibility = View.GONE
            } else {
                binding.photo.visibility = View.VISIBLE
                Glide.with(binding.photo).load(uri).into(binding.photo)
            }
        }*/

        /*binding.voiceCall.setOnClickListener {
            voiceCall()
        }*/
        binding.send.setOnClickListener {
            send()
        }
        /*binding.input.setOnEditorActionListener { _, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_SEND) {
                send()
                true
            } else {
                false
            }
        }*/
    }

    override fun onStart() {
        super.onStart()
        val foreground = arguments?.getBoolean(ARG_FOREGROUND) == true
        viewModel.foreground = foreground
    }

    override fun onStop() {
        super.onStop()
        viewModel.foreground = false
    }

    /*private fun voiceCall() {
        val contact = viewModel.contact.value ?: return
        startActivity(
            Intent(requireActivity(), VoiceCallActivity::class.java)
                .putExtra(VoiceCallActivity.EXTRA_NAME, contact.name)
                .putExtra(VoiceCallActivity.EXTRA_ICON_URI, contact.iconUri)
        )
    }*/

    private fun send() {
        if (binding.input.text.isNotEmpty()) {
            viewModel.send(currentUser.toString(), binding.input.text.toString())
            binding.input.text.clear()
        }
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        /*inflater.inflate(R.menu.chat, menu)
        menu.findItem(R.id.action_show_as_bubble)?.let { item ->
            viewModel.showAsBubbleVisible.observe(viewLifecycleOwner) { visible ->
                item.isVisible = visible
            }
        }
        super.onCreateOptionsMenu(menu, inflater)*/
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return false
    }
}