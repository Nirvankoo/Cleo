import SwiftUI

struct RootView: View {

    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            if authManager.currentUser != nil {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}
