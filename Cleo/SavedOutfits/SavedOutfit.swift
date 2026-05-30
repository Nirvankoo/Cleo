import Foundation

struct SavedOutfit: Codable, Identifiable {

    let outfitId: String
    let budget: Double
    let savedAt: Double

    var id: String {
        outfitId
    }
}
