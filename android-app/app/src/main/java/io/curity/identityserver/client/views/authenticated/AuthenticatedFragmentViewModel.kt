package io.curity.identityserver.client.views.authenticated

import android.net.Uri
import androidx.lifecycle.ViewModel
import io.curity.identityserver.client.configuration.ApplicationConfiguration
import io.curity.identityserver.client.errors.ApplicationException
import io.curity.identityserver.client.oauth.NonceService
import io.curity.identityserver.client.oauth.TokenState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class AuthenticatedFragmentViewModel(
    val configuration: ApplicationConfiguration,
    private val tokenState: TokenState,
    private val onError: (ApplicationException) -> Unit) : ViewModel() {

    fun createNonce(onSuccess: () -> Unit) {

        val that = this@AuthenticatedFragmentViewModel
        CoroutineScope(Dispatchers.IO).launch {

            try {

                val service = NonceService(that.configuration)
                val nonce = service.createNonce(that.tokenState.idToken)

                withContext(Dispatchers.Main) {
                    that.tokenState.nonce = nonce
                    println("DEBUG: nonce issued: $nonce")
                    onSuccess()
                }

            } catch (ex: ApplicationException) {

                withContext(Dispatchers.Main) {
                    that.onError(ex)
                }
            }
        }
    }

    fun getSpaUrl(): Uri {
        return Uri.parse("${this.configuration.baseUrl}${this.configuration.spaPath}?nonce=${this.tokenState.nonce}")
    }
}
