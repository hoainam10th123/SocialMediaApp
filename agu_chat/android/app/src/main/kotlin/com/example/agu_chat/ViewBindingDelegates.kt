package com.example.agu_chat

import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.viewbinding.ViewBinding

/**
 * Retrieves a view binding handle in an Activity.
 *
 * ```
 *     private val binding by viewBindings(MainActivityBinding::bind)
 *
 *     override fun onCreate(savedInstanceState: Bundle?) {
 *         super.onCreate(savedInstanceState)
 *         binding.someView.someField = ...
 *     }
 * ```
 */
inline fun <reified BindingT : ViewBinding> FragmentActivity.viewBindings(
    crossinline bind: (View) -> BindingT
) = object : Lazy<BindingT> {

    private var cached: BindingT? = null

    override val value: BindingT
        get() = cached ?: bind(
            findViewById<ViewGroup>(android.R.id.content).getChildAt(0)
        ).also {
            cached = it
        }

    override fun isInitialized() = cached != null
}

/**
 * Retrieves a view binding handle in a Fragment. The field is available only after
 * [Fragment.onViewCreated].
 *
 * ```
 *     private val binding by viewBindings(HomeFragmentBinding::bind)
 *
 *     override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
 *         binding.someView.someField = ...
 *     }
 * ```
 */
inline fun <reified BindingT : ViewBinding> Fragment.viewBindings(
    crossinline bind: (View) -> BindingT
) = object : Lazy<BindingT> {

    private var cached: BindingT? = null

    private val observer = LifecycleEventObserver { _, event ->
        if (event == Lifecycle.Event.ON_DESTROY) {
            cached = null
        }
    }

    override val value: BindingT
        get() = cached ?: bind(requireView()).also {
            viewLifecycleOwner.lifecycle.addObserver(observer)
            cached = it
        }

    override fun isInitialized() = cached != null
}
