## Mobile OAuth Flow

- Use built-in Swift coroutines
- Nonce should be created when the buttons are clicked, not on page load
- Stop ngrok in the teardown script

## Web OAuth Flow

- Debug using OAuth tools to sign in as the web client, and ensure that the authenticator is working
- Deploy oauth-agent
- Minor look and feel improvements to SPA
- Get local setup working for web development and add a sub README on local development
- SPA unauthenticated and authenticated views
- Use the nonce when the SPA loads with it as a query param
- Do I need WebViewCache?
- Filter out nonce authenticator from standard logins

## Android

- Equivalent behavior