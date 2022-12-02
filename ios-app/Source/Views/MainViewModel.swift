import Foundation

/*
 * The main view model, containing global objects
 */
class MainViewModel: ObservableObject {
    
    private let configuration: Configuration
    let isAuthenticated: Bool
    
    init() {
        self.configuration = ConfigurationLoader.load()
        self.isAuthenticated = false
    }
}
