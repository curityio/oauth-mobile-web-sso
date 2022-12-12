package io.curity.identityserver.client.views.unauthenticated

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.activityViewModels
import io.curity.identityserver.client.MainActivity
import io.curity.identityserver.client.MainActivityViewModel
import io.curity.identityserver.client.databinding.FragmentUnauthenticatedBinding

class UnauthenticatedFragment : androidx.fragment.app.Fragment() {

    private lateinit var binding: FragmentUnauthenticatedBinding

    private val loginActivity = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->

        this.onFinishLogin(result.data!!)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {

        this.binding = FragmentUnauthenticatedBinding.inflate(inflater, container, false)
        this.binding.fragment = this

        val mainViewModel: MainActivityViewModel by activityViewModels()
        val viewModel = mainViewModel.getUnauthenticatedViewModel()

        viewModel.loginCompleted.observe(viewLifecycleOwner) { event ->
            event?.getData()?.let {
                val mainActivity = this.activity as MainActivity
                mainActivity.navigateToAuthenticatedView()
            }
        }

        this.binding.model = viewModel
        return this.binding.root
    }

    fun login() {
        this.binding.model!!.startLogin(this.loginActivity::launch)
    }

    private fun onFinishLogin(responseIntent: Intent) {
        this.binding.model!!.finishLogin(responseIntent)
    }
}
