/*
 * Tokens held in memory
 */
struct TokenState {
    
    var idToken: String
    var nonce: String
    
    init(idToken: String) {
        self.idToken = idToken
        self.nonce = ""
    }
}
