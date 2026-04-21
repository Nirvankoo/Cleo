import SwiftUI
import FirebaseCore

@main
struct YourAppName: App {
    
    @StateObject private var appVM = AppViewModel()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(appVM)
        }
    }
}
