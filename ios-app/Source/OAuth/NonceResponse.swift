/*
 * Matches a successful response in a nonce request
 */
struct NonceResponse : Codable {
    var nonce: String
}
