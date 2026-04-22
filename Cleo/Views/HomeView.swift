import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @State private var budget: Double = 150
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - Top Section
                HStack {
                    
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color("TextPrimary"))
                    
                    Spacer()
                    
                    Text("Cleo")
                        .font(.custom("Manrope-SemiBold", size: 14))
                        .tracking(4)
                        .foregroundColor(Color("TextPrimary"))
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color("SurfaceLow"))
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // MARK: - Content
                VStack(spacing: 24) {
                    
                    // Title
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Find Your Outfit")
                            .font(.custom("Manrope-SemiBold", size: 22))
                            .foregroundColor(Color("TextPrimary"))
                        
                        Text("Define your aesthetic for the digital atelier.")
                            .font(.custom("Manrope-Regular", size: 14))
                            .foregroundColor(Color("TextPrimary"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // STYLE PERSONA
                    Text("STYLE PERSONA")
                        .font(.custom("Manrope-Medium", size: 10))
                        .tracking(1.5)
                        .foregroundColor(Color("TextPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            PersonaButton(title: "Casual", isSelected: false)
                            PersonaButton(title: "Chic", isSelected: true)
                        }
                        HStack(spacing: 12) {
                            PersonaButton(title: "Sport", isSelected: false)
                            PersonaButton(title: "Streetwear", isSelected: false)
                        }
                    }
                    
                    // MARK: - Budget Card
                    VStack(spacing: 16) {
                        HStack {
                            Text("INVESTMENT")
                                .font(.custom("Manrope-Medium", size: 10))
                                .tracking(1.5)
                                .foregroundColor(Color("TextPrimary"))
                            
                            Spacer()
                            
                            Text("$\(Int(budget))")
                                .font(.custom("Manrope-SemiBold", size: 18))
                                .foregroundColor(Color("TextPrimary"))
                        }
                        
                        Slider(value: $budget, in: 50...300)
                            .tint(Color("TextPrimary"))
                        
                        HStack {
                            Text("$50")
                                .font(.custom("Manrope-Regular", size: 12))
                                .foregroundColor(Color("TextPrimary"))
                            
                            Spacer()
                            
                            Text("$300")
                                .font(.custom("Manrope-Regular", size: 12))
                                .foregroundColor(Color("TextPrimary"))
                        }
                    }
                    .padding(16)
                    .background(Color("SurfaceLow"))
                    .cornerRadius(16)
                    
                    // MARK: - Complexion
                    VStack(alignment: .leading, spacing: 12) {
                        Text("COMPLEXION PALETTE")
                            .font(.custom("Manrope-Medium", size: 10))
                            .tracking(1.5)
                            .foregroundColor(Color("TextPrimary"))
                        
                        HStack(spacing: 12) {
                            ColorCircle(color: "#E6CFC0", isSelected: false)
                            ColorCircle(color: "#D9B89F", isSelected: false)
                            ColorCircle(color: "#C89A75", isSelected: true)
                            ColorCircle(color: "#A96F4B", isSelected: false)
                            ColorCircle(color: "#7A4A2C", isSelected: false)
                            ColorCircle(color: "#4A2A18", isSelected: false)
                        }
                    }
                    
                    // MARK: - Occasion
                    VStack(alignment: .leading, spacing: 12) {
                        Text("THE OCCASION")
                            .font(.custom("Manrope-Medium", size: 10))
                            .tracking(1.5)
                            .foregroundColor(Color("TextPrimary"))
                        
                        VStack(spacing: 10) {
                            HStack(spacing: 10) {
                                CapsuleButton(title: "Work", selected: false)
                                CapsuleButton(title: "Date", selected: true)
                                CapsuleButton(title: "Party", selected: false)
                            }
                            
                            HStack(spacing: 10) {
                                CapsuleButton(title: "Travel", selected: false)
                                CapsuleButton(title: "Everyday", selected: false)
                            }
                        }
                    }
                    
                    // MARK: - Seasonal
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SEASONAL MOOD")
                            .font(.custom("Manrope-Medium", size: 10))
                            .tracking(1.5)
                            .foregroundColor(Color("TextPrimary"))
                        
                        HStack(spacing: 16) {
                            MoodIcon(system: "snowflake", label: "WINTER", selected: false)
                            MoodIcon(system: "leaf", label: "SPRING", selected: true)
                            MoodIcon(system: "sun.max", label: "SUMMER", selected: false)
                            MoodIcon(system: "leaf.fill", label: "FALL", selected: false)
                        }
                    }
                    
                    // MARK: - Button
                    Button {
                        print("Generate outfit tapped")
                    } label: {
                        Text("GENERATE OUTFIT")
                            .font(.custom("Manrope-Medium", size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
        .background(Color("AppBackground"))
    }
}

#Preview {
    HomeView().environmentObject(AppViewModel())
}
