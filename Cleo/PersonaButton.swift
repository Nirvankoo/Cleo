import SwiftUI

struct PersonaButton: View {
    
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.custom("Manrope-Regular", size: 14))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected
                ? Color.gray.opacity(0.6)
                : Color.gray.opacity(0.1)
            )
            .foregroundColor(isSelected ? .white : .black)
            .clipShape(Capsule())
    }
}
