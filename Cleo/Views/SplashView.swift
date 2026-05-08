import SwiftUI

struct SplashView: View {
    
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            
            Image("cleo_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
        }
    }
}
