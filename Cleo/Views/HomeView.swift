import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Welcome!")
                .font(.largeTitle)
            
            Button("Logout") {
                appVM.logout()
            }
        }
        .padding()
    }
}
