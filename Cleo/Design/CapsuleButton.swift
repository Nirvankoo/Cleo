import SwiftUI

struct CapsuleButton: View {
    
    let title: String
    let selected: Bool
    
    var body: some View {
        Text(title)
            .font(.custom("Manrope-Regular", size: 14))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(selected ? Color.gray.opacity(0.7) : Color.gray.opacity(0.1))
            .foregroundColor(selected ? .white : .black)
            .clipShape(Capsule())
    }
}
