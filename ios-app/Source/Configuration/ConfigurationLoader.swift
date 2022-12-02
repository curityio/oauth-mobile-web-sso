import Foundation

/*
 * A helper class to load configuration
 */
struct ConfigurationLoader {

    /*
     * Load configuration from the embedded resource
     */
    static func load() -> Configuration {

        let filePath = Bundle.main.path(forResource: "mobile-config", ofType: "json")!
        let jsonText = try! String(contentsOfFile: filePath)
        let jsonData = jsonText.data(using: .utf8)!

        return try! JSONDecoder().decode(Configuration.self, from: jsonData)
    }
}
