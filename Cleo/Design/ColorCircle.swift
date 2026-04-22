import SwiftUI

struct ColorCircle: View {
    
    let color: String
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: color))
                .frame(width: 40, height: 40)
            
            if isSelected {
                Circle()
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 46, height: 46)
            }
        }
    }
}
