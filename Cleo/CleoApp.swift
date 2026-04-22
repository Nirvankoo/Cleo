import SwiftUI
import FirebaseCore

@main
struct YourAppName: App {
    
    @StateObject private var appVM = AppViewModel()
    @StateObject private var session = SessionManager() // 👈 ADD THIS

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(appVM)
                .environmentObject(session) // 👈 ADD THIS
        }
    }
}
