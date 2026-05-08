import SwiftUI

struct MoodIcon: View {
    
    let system: String
    let label: String
    let selected: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            
            Image(systemName: system)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(selected ? .white : Color("TextPrimary"))
                .frame(width: 44, height: 44)
                .background(
                    selected ? Color("CleoPrimary") : Color.clear
                )
                .clipShape(Circle())
            
            Text(label)
                .font(.custom("Manrope-Regular", size: 10))
                .foregroundColor(selected ? Color("CleoPrimary") : Color("TextPrimary"))
        }
    }
}
