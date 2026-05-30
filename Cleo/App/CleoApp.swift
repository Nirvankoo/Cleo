import SwiftUI
import FirebaseCore

@main
struct YourAppName: App {
    
    @StateObject private var appVM = AppViewModel()
    @StateObject private var authManager = AuthManager()
    @StateObject private var savedOutfitManager = SavedOutfitManager()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .environmentObject(appVM)
                    .environmentObject(authManager)
                    .environmentObject(savedOutfitManager)
                    .onAppear {
                        savedOutfitManager.loadSavedOutfits()
                    }
                
                SplashLayer()
            }
            .preferredColorScheme(.light)
        }
    }
    
    struct SplashLayer: View {
        
        @State private var isVisible = true
        
        var body: some View {
            if isVisible {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isVisible = false
                        }
                    }
            }
        }
    }
}
