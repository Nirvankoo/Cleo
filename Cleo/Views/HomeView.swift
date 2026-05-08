import SwiftUI

struct HomeView: View {
    
    // MARK: - Environment
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var authManager: AuthManager
    
    // MARK: - State
    @State private var budget: Double = 150
    @State private var selectedPersona: String = "Chic"
    @State private var selectedOccasion: String = "Date"
    @State private var selectedSeason: String = "SPRING"
    @State private var selectedSkinTone: String = "#C89A75"
    
    @State private var navigate = false
    @State private var generatedPreferences: OutfitPreferences?
    
    @State private var showMenu = false
    
    // MARK: - UI
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                
                TopMenu()
                
                VStack(spacing: 24) {
                    
                    // MARK: Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Find your perfect outfit")
                            .font(.custom("Manrope-SemiBold", size: 22))
                            .foregroundColor(Color("TextPrimary"))
                        
                        Text("Tailored to your style and budget")
                            .font(.custom("Manrope-Regular", size: 14))
                            .foregroundColor(Color("TextPrimary"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: Persona
                    VStack(alignment: .leading, spacing: 12) {
                        
                        sectionTitle("STYLE")
                            .font(.custom("Manrope-Medium", size: 12))
                            .foregroundColor(Color("TextPrimary"))
                        
                        VStack(spacing: 12) {
                            
                            HStack(spacing: 12) {
                                styleButton("Casual")
                                styleButton("Chic")
                            }
                            
                            HStack(spacing: 12) {
                                styleButton("Sport")
                                styleButton("Streetwear")
                            }
                        }
                    }
                    
                    // MARK: Budget
                    VStack(spacing: 16) {
                        
                        HStack {
                            sectionTitle("BUDGET")
                            Spacer()
                            Text("$\(Int(budget))")
                        }
                        
                        Slider(value: $budget, in: 50...300)
                        
                        HStack {
                            Text("$50")
                            Spacer()
                            Text("$300")
                        }
                    }
                    .padding(16)
                    .background(Color("SurfaceLow"))
                    .cornerRadius(16)
                    
                    // MARK: Skin Tone
                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("SKIN TONE")
                        
                        HStack(spacing: 12) {
                            skinToneButton(color: "#E6CFC0", type: "fair")
                            skinToneButton(color: "#C89A75", type: "medium")
                            skinToneButton(color: "#A96F4B", type: "tan")
                            skinToneButton(color: "#4A2A18", type: "deep")
                        }
                    }
                    
                    // MARK: Occasion
                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("THE OCCASION")
                        
                        VStack(spacing: 10) {
                            
                            HStack {
                                occasionButton("Work")
                                occasionButton("Date")
                                occasionButton("Party")
                            }
                            
                            HStack {
                                occasionButton("Travel")
                                occasionButton("Everyday")
                            }
                        }
                    }
                    
                    // MARK: Season
                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("SEASON")
                        
                        HStack {
                            seasonButton("WINTER", icon: "snowflake")
                            seasonButton("SPRING", icon: "leaf")
                            seasonButton("SUMMER", icon: "sun.max")
                            seasonButton("FALL", icon: "leaf.fill")
                        }
                    }
                    
                    // MARK: Generate Button
                    Button {
                        generateOutfit()
                    } label: {
                        Text("GENERATE OUTFIT")
                            .font(.custom("Manrope-SemiBold", size: 14))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color("CleoPrimary"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                }
                               .padding(.horizontal, 24)
                               .padding(.top, 20)
                           }
                       }
                       .background(Color("AppBackground"))
                       .sheet(isPresented: $showMenu) {
                           menuSheet
                       }
                       .navigationDestination(isPresented: $navigate) {
                           if let preferences = generatedPreferences {
                               OutfitView(preferences: preferences)
                           }
                       }
                   }
               }
}

// MARK: - Components
extension HomeView {
    
    private func styleButton(_ title: String) -> some View {
        StyleButton(title: title, isSelected: selectedPersona == title)
            .onTapGesture { selectedPersona = title }
    }
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.custom("Manrope-Medium", size: 12))
            .foregroundColor(Color("TextPrimary"))
    }
    private func occasionButton(_ title: String) -> some View {
        CapsuleButton(title: title, selected: selectedOccasion == title)
            .onTapGesture { selectedOccasion = title }
    }
    
    private func seasonButton(_ label: String, icon: String) -> some View {
        MoodIcon(system: icon, label: label, selected: selectedSeason == label)
            .onTapGesture { selectedSeason = label }
    }
    
    private func skinToneButton(color: String, type: String) -> some View {
        ColorCircle(color: color, isSelected: selectedSkinTone == type)
            .onTapGesture { selectedSkinTone = type }
    }
    
    private func navigateToResult(preferences: OutfitPreferences) {
        self.generatedPreferences = preferences
        self.navigate = true
    }
}

// MARK: - Logic
extension HomeView {
    
    private func generateOutfit() {
        let preferences = buildPreferences()
        navigateToResult(preferences: preferences)
    }
    
    private func buildPreferences() -> OutfitPreferences {
        OutfitPreferences(
            persona: selectedPersona,
            occasion: selectedOccasion,
            season: selectedSeason,
            skinTone: selectedSkinTone,
            budget: budget
        )
    }
}

// MARK: - Menu
extension HomeView {
    
    private var menuSheet: some View {
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

#Preview {
    HomeView()
        .environmentObject(AppViewModel())
        .environmentObject(AuthManager())
}
