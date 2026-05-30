import SwiftUI

struct SavedOutfitsView: View {

    @EnvironmentObject
    var savedOutfitManager: SavedOutfitManager

    @StateObject
    private var engine = OutfitEngine()

    var body: some View {

        let outfits =
            savedOutfitManager.savedOutfits(
                from: engine.outfits
            )

        NavigationStack{

            List(outfits) { outfit in

                NavigationLink {

                    SavedOutfitDetailView(
                        outfit: outfit,
                        userBudget: savedOutfitManager.savedBudget(
                            for: outfit.outfit_id
                        )
                    )

                } label: {

                    HStack {

                        Image(outfit.outfit_id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)

                        VStack(alignment: .leading) {

                            Text(outfit.style.capitalized)

                            Text(outfit.occasion.capitalized)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        VStack(spacing: 12) {

                            Button {

                                savedOutfitManager.removeSavedOutfit(
                                    outfitId: outfit.outfit_id
                                )

                            } label: {

                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                            
                        }
                    }
                }
            }
            .navigationTitle(
                "Saved Outfits"
            )
        }
    }
}
