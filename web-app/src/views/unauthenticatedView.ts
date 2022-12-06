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

import {OAuthClient} from '../oauthClient';
import {ErrorView} from './errorView';
import {Elements} from './elements';
import {Utils} from './utils';

/*
 * Presented before the web user is authenticated
 */
export class UnauthenticatedView {

    private readonly oauthClient: OAuthClient;

    public constructor(oauthClient: OAuthClient) {

        this.oauthClient = oauthClient;
        Utils.createContainer(Elements.Main);
        this.setupCallbacks();
    }

    public render() {

        const html = `<div>
                        <p>User is unauthenticated<p>
                        <button id='btnLogin'>Sign In</button>
                      </div>`;

        Utils.setContainerContent(Elements.Main, html);
        document.querySelector('#btnLogin')?.addEventListener('click', this.onLogin);
    }

    public async onLogin() {
        
        try {

            ErrorView.clear();
            this.oauthClient.startLogin();

        } catch (e: any) {

            ErrorView.render(e);
        }
    }

    private setupCallbacks() {
        this.onLogin = this.onLogin.bind(this);
    }
}
