//
// Copyright (C) 2022 Curity AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

/*
 * The iframe app's only role is to receive an OpenID Connect response
 */
export class IframeApp {

    /*
     * Use the post message API to send the authorization response to the parent window
     */
    public execute() {

        console.log(`DEBUG SPA: silent login response: ${location.href}`);
        window.parent.postMessage(location.href);
    }
}
