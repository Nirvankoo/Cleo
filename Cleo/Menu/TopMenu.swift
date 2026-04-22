import SwiftUI

struct TopMenu: View {
    
    var body: some View {
        HStack {
            
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20, weight: .medium))
            
            Spacer()
            
            Text("ATELIER")
                .font(.custom("Manrope-SemiBold", size: 14))
                .tracking(4)
            
            Spacer()
            
            Circle()
                .fill(Color.gray)
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}
