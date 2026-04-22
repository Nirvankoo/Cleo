import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var session: SessionManager
    
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            if session.isLoggedIn {
                HomeView()
                    .environmentObject(appVM)
            } else {
                LoginView()
            }
        } else {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                
                Image("cleo_logo")
                    .interpolation(.none)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 300)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isActive = true
                }
            }
        }
    }
}
