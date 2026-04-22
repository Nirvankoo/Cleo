import SwiftUI

struct MoodIcon: View {
    
    let system: String
    let label: String
    let selected: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            
            Image(systemName: system)
                .font(.system(size: 18))
                .frame(width: 40, height: 40)
                .background(selected ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(label)
                .font(.custom("Manrope-Regular", size: 10))
                .foregroundColor(.gray)
        }
    }
}
