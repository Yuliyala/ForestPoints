import SwiftUI

@main
struct ForestPointsApp: App {
    init() {
        _ = CollectionService.shared
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
