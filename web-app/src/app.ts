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

import {OAuthClient} from './oauthClient';
import {TitleView} from './views/titleView';
import {ErrorView} from './views/errorView';
import {AuthenticatedView} from './views/authenticatedView';
import {UnauthenticatedView} from './views/unauthenticatedView';

/*
 * The visible SPA application
 */
class App {

    private readonly unauthenticatedView: UnauthenticatedView;
    private readonly authenticatedView: AuthenticatedView;
    private readonly oauthClient: OAuthClient;

    public constructor() {

        this.oauthClient = new OAuthClient();
        TitleView.create();
        ErrorView.create();
        this.unauthenticatedView = new UnauthenticatedView(this.oauthClient);
        this.authenticatedView = new AuthenticatedView(this.oauthClient);
    }

    public async execute(): Promise<void> {

        try {
        
            TitleView.render();

            const hasNonce = await this.oauthClient.handleNonce()
            if (!hasNonce) {

                const isAuthenticated = await this.oauthClient.handlePageLoad();
                if (isAuthenticated) {
                    this.authenticatedView.render();
                } else {
                    this.unauthenticatedView.render();
                }
            }

        } catch (e: any) {

            ErrorView.render(e);
        }
    }
}

const app = new App();
app.execute();