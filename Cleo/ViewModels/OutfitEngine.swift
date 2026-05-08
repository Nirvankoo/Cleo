import Foundation
import Combine

class OutfitEngine: ObservableObject {

    @Published var outfits: [Outfit] = []
    @Published var stores: [Store] = []

    init() {
        loadData()
    }

    private func loadData() {
        outfits = DataLoader.loadJSON("outfits", as: [Outfit].self)
        stores = DataLoader.loadJSON("stores", as: [Store].self)
    }

    // MARK: - OUTFIT SELECTION (CORE LOGIC)

   
    func getBestOutfits(preferences: OutfitPreferences) -> [Outfit] {
        
        let scored: [(Outfit, Int)] = outfits.map { outfit in
            var score = 0
            
            if outfit.style == preferences.persona { score += 5 }
            if outfit.occasion == preferences.occasion { score += 5 }
            if outfit.season == preferences.season { score += 3 }
            if outfit.skin_tone == preferences.skinTone { score += 3 }
            
            if isOutfitBudgetMatch(outfitBudget: outfit.budget,
                                  userBudget: preferences.budget) {
                score += 4
            }
            
            return (outfit, score)
        }
        
        // Sort by score (highest first)
        let sorted = scored.sorted { $0.1 > $1.1 }
        
        // DEBUG
        print("---- OUTFIT SCORES ----")
        sorted.forEach { print("\($0.0.outfit_id): \($0.1)") }
        
        // Take top matches (NOT just 3, but top 5 max)
        let top = Array(sorted.prefix(5))
        
        // Add randomness so it's not always same order
        let shuffled = top.shuffled()
        
        return shuffled.map { $0.0 }
    }
    

    


    // MARK: - STORE MATCHING
    func getStores(for outfit: Outfit, userBudget: Double) -> [Store] {

        return stores.filter { store in

            // Budget match
            guard isStoreBudgetMatch(storeRange: store.budget_range,
                                     userBudget: userBudget) else { return false }

            // Style match
            guard store.style_tags.contains(outfit.style) else { return false }

            // Season match
            if !store.season_strength.contains(outfit.season) &&
               !store.season_strength.contains("all") {
                return false
            }

            return true
        }
    }
    func getStoreForItem(_ item: OutfitItem, userBudget: Double) -> Store? {
        
        return stores.first { store in
            
            // Budget match
            guard isStoreBudgetMatch(storeRange: store.budget_range,
                                     userBudget: userBudget) else { return false }
            
            // Smart mapping by item type
            let type = item.type
            
            if ["heels", "blazer", "dress", "tote_bag", "shoulder_bag"].contains(type) {
                return store.name.lowercased().contains("zara")
            }
            
            if ["sneakers", "shorts", "tank_top", "hoodie"].contains(type) {
                return store.name.lowercased().contains("nike")
            }
            
            if ["leggings", "gym_bag"].contains(type) {
                return store.name.lowercased().contains("lululemon")
            }
            
            // fallback
            return true
        }
    }

    // MARK: - HELPERS

    private func isOutfitBudgetMatch(outfitBudget: String,
                                    userBudget: Double) -> Bool {

        let parts = outfitBudget.split(separator: "-")

        guard parts.count == 2,
              let min = Double(parts[0]),
              let max = Double(parts[1]) else {
            return false
        }

        return userBudget >= min && userBudget <= max
    }

    private func isStoreBudgetMatch(storeRange: String,
                                   userBudget: Double) -> Bool {

        let parts = storeRange.split(separator: "-")

        guard parts.count == 2,
              let min = Double(parts[0]),
              let max = Double(parts[1]) else {
            return false
        }

        return userBudget >= min && userBudget <= max
    }
}

