## Mobile OAuth Flow

- Mobile AppAuth, with prompt=login and error handling, then print the ID token
- Get a nonce and pass it to the webview
- Use OAuth tools to sign in as the web client
- Update docs to show the journey

## Web OAuth Flow

- Deploy oauth-agent and get SPA to use it to login if it has no cookie yet
- Get local setup working for web development and document it
- Use the nonce when the SPA loads with it as a query param
- Filter out nonce authenticator from standard logins
