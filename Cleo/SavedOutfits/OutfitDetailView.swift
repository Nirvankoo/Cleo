import SwiftUI

struct OutfitDetailView: View {

    let outfit: Outfit
    let preferences: OutfitPreferences

    @EnvironmentObject var savedOutfitManager: SavedOutfitManager

    @StateObject private var engine = OutfitEngine()

    var body: some View {

        ScrollView {

            VStack(spacing: 18) {

                Image(outfit.outfit_id)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 360)

                Text("Outfit Detail View")
                    .font(.headline)

                Text(outfit.style.capitalized)
            }
            .padding()
        }
    }
}
