import SwiftUI

struct StyleButton: View {
    
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.custom("Manrope-Medium", size: 14))
            .foregroundColor(isSelected ? .white : Color("TextPrimary"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected
                ? Color("CleoPrimary")
                : Color("SurfaceLow")
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color("CleoPrimary") : Color.clear,
                        lineWidth: 2
                    )
            )
    }
}
