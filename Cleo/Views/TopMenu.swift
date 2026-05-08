import SwiftUI

struct TopMenu: View {
    
    @EnvironmentObject var authManager: AuthManager
    @State private var showMenu = false
    
    var body: some View {
        HStack {
            
            Button {
                print("MENU TAPPED") // 👈 debug
                showMenu = true
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("TextPrimary"))
            }
            
            Spacer()
            
            Text("CLEO")
                .font(.custom("Manrope-SemiBold", size: 14))
                .tracking(4)
                .foregroundColor(Color("TextPrimary"))
            
            Spacer()
            
            Circle()
                .fill(Color("SurfaceLow"))
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        
        .sheet(isPresented: $showMenu) {
            VStack(spacing: 20) {
                
                Text("Menu")
                    .font(.title)
                
                Button {
                    authManager.signOut()
                    showMenu = false
                } label: {
                    Text("Logout")
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
