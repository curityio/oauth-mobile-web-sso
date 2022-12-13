/*
 *  Copyright 2022 Curity AB
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package io.curity.identityserver.client.oauth

import com.google.gson.Gson
import io.curity.identityserver.client.configuration.ApplicationConfiguration
import io.curity.identityserver.client.errors.ApplicationException
import okhttp3.Call
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import java.io.IOException
import java.util.concurrent.TimeUnit
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

class NonceService(private val configuration: ApplicationConfiguration) {

    suspend fun createNonce(idToken: String): String {

        val url = "${this.configuration.baseUrl}${this.configuration.nonceAuthenticatorPath}"
        val body = "token=$idToken".toRequestBody()

        val builder = Request.Builder()
            .header("Content-Type", "application/x-www-form-urlencoded")
            .method("POST", body)
            .url(url)
        val request = builder.build()

        return suspendCoroutine { continuation ->

            val client = OkHttpClient.Builder()
                .callTimeout(10, TimeUnit.SECONDS)
                .build()

            client.newCall(request).enqueue(object : Callback {
                override fun onResponse(call: Call, response: Response) {

                    if (!isValidResponseStatus(response.code)) {

                        // Report response errors
                        val error = ApplicationException("Nonce Response Error", "Nonce request failed: ${response.code}")
                        continuation.resumeWithException(error)

                    } else {

                        // Return the data on success
                        val responseJson = response.body?.string()
                        val nonceResponse = Gson().fromJson(responseJson, NonceResponse::class.java)
                        continuation.resumeWith(Result.success(nonceResponse.nonce))
                    }
                }

                override fun onFailure(call: Call, e: IOException) {

                    // Translate the API error
                    val error = ApplicationException("Nonce Request Error", "Failure during nonce HTTP request")
                    continuation.resumeWithException(error)
                }
            })
        }
    }

    private fun isValidResponseStatus(code: Int): Boolean {
        return code >= 200 && code <= 299
    }
}