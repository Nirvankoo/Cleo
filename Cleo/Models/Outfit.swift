import Foundation

struct Outfit: Codable, Identifiable {
    let outfit_id: String
    let style: String
    let occasion: String
    let season: String
    let budget: String // keep for now, but later remove from filtering
    let skin_tone: String
    let items: [OutfitItem]

    var id: String { outfit_id }
}

struct OutfitItem: Codable {
    let type: String
    let color: String?
    let fit: String?
    let style: String?
    let material: String?
}
