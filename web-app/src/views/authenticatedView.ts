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
 * Presented after the web user is authenticated
 */
export class AuthenticatedView {

    private readonly oauthClient: OAuthClient;

    public constructor(oauthClient: OAuthClient) {

        this.oauthClient = oauthClient;
        Utils.createContainer(Elements.Main);
        this.setupCallbacks();
    }

    public render() {

        const html = `<div>
                        <p>Welcome ${this.oauthClient.getSubject()}<p>
                        <button id='btnLogout'>Sign Out</button>
                      </div>`;
        
        Utils.setContainerContent(Elements.Main, html);
        document.querySelector('#btnLogout')?.addEventListener('click', this.onLogout);
    }

    public async onLogout() {
        
        try {

            ErrorView.clear();
            await this.oauthClient.logout();

        } catch (e: any) {

            console.log(`DEBUG SPA: logout error: ${e}`);
        }
    }

    private setupCallbacks() {
        this.onLogout = this.onLogout.bind(this);
    }
}
