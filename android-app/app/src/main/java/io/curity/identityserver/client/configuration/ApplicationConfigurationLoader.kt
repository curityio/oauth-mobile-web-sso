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

package io.curity.identityserver.client.configuration

import android.content.Context
import com.google.gson.Gson
import io.curity.identityserver.client.R
import okio.buffer
import okio.source
import java.nio.charset.Charset

class ApplicationConfigurationLoader {

    fun load(context: Context): ApplicationConfiguration {

        val stream = context.resources.openRawResource(R.raw.config)
        val configSource = stream.source().buffer()

        val configBuffer = okio.Buffer()
        configSource.readAll(configBuffer)
        val configJson = configBuffer.readString(Charset.forName("UTF-8"))

        return Gson().fromJson(configJson, ApplicationConfiguration::class.java)
    }
}