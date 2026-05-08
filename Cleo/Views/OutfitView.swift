import SwiftUI

struct OutfitView: View {
    
    @StateObject var engine = OutfitEngine()
    let preferences: OutfitPreferences
    
    @State private var selectedIndex = 0
    
    var body: some View {
        
        let outfits = engine.getBestOutfits(preferences: preferences)
        
        return VStack {
            
            if outfits.isEmpty {
                Text("No outfits found")
                    .font(.headline)
            } else {
                
                let safeIndex = min(selectedIndex, outfits.count - 1)
                let outfit = outfits[safeIndex]
                
            
                
                ScrollView {
                    VStack(spacing: 18) {
                        
                        // MARK: - Outfit Image
                        Image(outfit.outfit_id)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 420)
                            .clipped()
                            .cornerRadius(20)
                        
                        // MARK: - HEADER
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("Items in this Outfit")
                                .font(.custom("Manrope-SemiBold", size: 18))
                            
                            Text("Curated pieces for a cohesive aesthetic.")
                                .font(.custom("Manrope-Regular", size: 13))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // MARK: - ITEMS LIST
                        VStack(spacing: 10) {
                            ForEach(outfit.items, id: \.type) { item in
                                
                                let store = engine.getStoreForItem(item, userBudget: preferences.budget)
                                
                                HStack(spacing: 16) {
                                    
                                    // ICON (BIGGER + CLEARER)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color("SurfaceLow"))
                                            .frame(width: 56, height: 56) // slightly smaller container

                                        Image(item.type)
                                            .resizable()
                                            .scaledToFill()   // 👈 KEY CHANGE
                                            .frame(width: 52, height: 52) // bigger
                                            .clipped()        // 👈 removes empty edges
                                    }
                                    
                                    // TEXT
                                    VStack(alignment: .leading, spacing: 6) {
                                        
                                        Text(item.type.capitalized)
                                            .font(.custom("Manrope-SemiBold", size: 16))
                                        
                                        Text(itemDescription(item))
                                            .font(.custom("Manrope-Regular", size: 13))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // BUTTON
                                    if let store = store {
                                        Button {
                                            openSearchForItem(store: store, item: item)
                                        } label: {
                                            Text("Shop Now")
                                                .font(.custom("Manrope-Medium", size: 13))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(Color("CleoPrimary"))
                                                .cornerRadius(22)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color("SurfaceLow"))
                                .cornerRadius(18)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
        }
    }
}

// MARK: - HELPERS
extension OutfitView {
    
    func openSearchForItem(store: Store, item: OutfitItem) {
        
        var parts: [String] = []
        
        if let color = item.color { parts.append(color) }
        if let fit = item.fit { parts.append(fit) }
        if let style = item.style { parts.append(style) }
        if let material = item.material { parts.append(material) }
        
        parts.append(item.type)
        
        let query = parts.joined(separator: " ")
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString = store.search_template
            .replacingOccurrences(of: "{query}", with: encodedQuery)
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func itemDescription(_ item: OutfitItem) -> String {
        var parts: [String] = []
        
        if let color = item.color { parts.append(color) }
        if let fit = item.fit { parts.append(fit) }
        if let style = item.style { parts.append(style) }
        if let material = item.material { parts.append(material) }
        
        return parts.joined(separator: " ")
    }
}

