import Foundation
import Combine

class OutfitEngine: ObservableObject {

    @Published var outfits: [Outfit] = []
    @Published var stores: [Store] = []

    init() {
        loadData()
    }

    private func loadData() {
        outfits = DataLoader.loadJSON(
            "outfits",
            as: [Outfit].self
        )

        stores = DataLoader.loadJSON(
            "stores",
            as: [Store].self
        )
    }

    // MARK: - OUTFIT SELECTION

    func getBestOutfits(
        preferences: OutfitPreferences
    ) -> [Outfit] {

        let scored: [(Outfit, Int)] = outfits.map { outfit in

            var score = 0

            if outfit.style.lowercased()
                == preferences.persona.lowercased() {
                score += 5
            }

            if outfit.occasion.lowercased()
                == preferences.occasion.lowercased() {
                score += 5
            }

            if outfit.season.lowercased()
                == preferences.season.lowercased() {
                score += 3
            }

            if outfit.skin_tone.lowercased()
                == preferences.skinTone.lowercased() {
                score += 3
            }

            if isOutfitBudgetMatch(
                outfitBudget: outfit.budget,
                userBudget: preferences.budget
            ) {
                score += 4
            }

            return (outfit, score)
        }

        let sorted = scored.sorted {
            $0.1 > $1.1
        }

        print("---- OUTFIT SCORES ----")

        sorted.forEach {
            print("\($0.0.outfit_id): \($0.1)")
        }

        let top = Array(sorted.prefix(3))

        return top.map { $0.0 }
    }

    // MARK: - STORE MATCHING

    func getStores(
        for outfit: Outfit,
        userBudget: Double
    ) -> [Store] {

        return stores.filter { store in

            guard isStoreBudgetMatch(
                storeRange: store.budget_range,
                userBudget: userBudget
            ) else {
                return false
            }

            let styleMatch =
                store.style_tags.contains {
                    $0.lowercased()
                    == outfit.style.lowercased()
                }

            if !styleMatch {
                return false
            }

            let seasonMatch =
                store.season_strength.contains {
                    $0.lowercased()
                    == outfit.season.lowercased()
                }

            return seasonMatch
        }
    }

    func getStoreForItem(
        _ item: OutfitItem,
        style: String,
        userBudget: Double
    ) -> Store? {

        let matchingStores = stores.filter { store in

            guard isStoreBudgetMatch(
                storeRange: store.budget_range,
                userBudget: userBudget
            ) else {
                return false
            }

            return store.item_types.contains {
                $0.lowercased()
                == item.type.lowercased()
            }
        }

        // fallback if item type not found
        if matchingStores.isEmpty {

            return stores.first {
                isStoreBudgetMatch(
                    storeRange: $0.budget_range,
                    userBudget: userBudget
                )
            }
        }

        let scored = matchingStores.map {
            store -> (Store, Int) in

            var score = 0

            if store.style_tags.contains(where: {
                $0.lowercased()
                == style.lowercased()
            }) {
                score += 5
            }

            // cheaper stores slightly preferred
            score += (4 - store.price_level)

            return (store, score)
        }

        return scored
            .sorted { $0.1 > $1.1 }
            .first?
            .0
    }

    // MARK: - HELPERS

    private func isOutfitBudgetMatch(
        outfitBudget: String,
        userBudget: Double
    ) -> Bool {

        let cleaned =
            outfitBudget.replacingOccurrences(
                of: "–",
                with: "-"
            )

        let parts = cleaned.split(
            separator: "-"
        )

        guard parts.count == 2,
              let min = Double(parts[0]),
              let max = Double(parts[1])
        else {
            return false
        }

        return userBudget >= min &&
               userBudget <= max
    }

    private func isStoreBudgetMatch(
        storeRange: String,
        userBudget: Double
    ) -> Bool {

        let cleaned =
            storeRange.replacingOccurrences(
                of: "–",
                with: "-"
            )

        let parts = cleaned.split(
            separator: "-"
        )

        guard parts.count == 2,
              let min = Double(parts[0]),
              let max = Double(parts[1])
        else {
            return false
        }

        return userBudget >= min &&
               userBudget <= max
    }
}
