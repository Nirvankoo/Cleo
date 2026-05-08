import SwiftUI

struct CapsuleButton: View {
    
    let title: String
    let selected: Bool
    
    var body: some View {
        Text(title)
            .font(.custom("Manrope-Medium", size: 13))
            .foregroundColor(selected ? .white : Color("TextPrimary"))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                selected
                ? Color("CleoPrimary")
                : Color("SurfaceLow")
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        selected ? Color("CleoPrimary") : Color.gray.opacity(0.2),
                        lineWidth: 1.5
                    )
            )
    }
}
