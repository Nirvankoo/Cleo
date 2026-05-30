import SwiftUI
import UIKit

struct OutfitView: View {
    
    @EnvironmentObject var savedOutfitManager: SavedOutfitManager

    @StateObject var engine = OutfitEngine()

    @State private var selectedOutfit: Outfit?

    let preferences: OutfitPreferences
    
    
    var body: some View {

        VStack {

            if let outfit = selectedOutfit {

                ScrollView {

                    VStack(spacing: 18) {

                        // MARK: - Outfit Image
                        Image(outfit.outfit_id)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 360)
                            .padding(.horizontal, 12)
                            .background(Color("SurfaceLow"))
                            .cornerRadius(20)
                            .shadow(
                                color: .black.opacity(0.06),
                                radius: 10,
                                y: 4
                            )

                        Button {

                            savedOutfitManager.saveOutfit(
                                outfitId: outfit.outfit_id,
                                budget: preferences.budget
                            )

                        } label: {

                            HStack(spacing: 8) {

                                Image(
                                    systemName:
                                        savedOutfitManager.isSaved(
                                            outfit.outfit_id
                                        )
                                        ? "heart.fill"
                                        : "heart"
                                )
                                .foregroundColor(
                                    savedOutfitManager.isSaved(
                                        outfit.outfit_id
                                    )
                                    ? .red
                                    : .white
                                )
                                Text(
                                    savedOutfitManager.isSaved(
                                        outfit.outfit_id
                                    )
                                    ? "Saved"
                                    : "Save Outfit"
                                )
                            }
                            .font(.custom("Manrope-SemiBold", size: 15))
                            .foregroundColor(
                                savedOutfitManager.isSaved(
                                    outfit.outfit_id
                                )
                                ? .green
                                : .white
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Color("CleoPrimary")
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        savedOutfitManager.isSaved(
                                            outfit.outfit_id
                                        )
                                        ? Color.green
                                        : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .cornerRadius(14)
                        }

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

                                let store = engine.getStoreForItem(
                                    item,
                                    style: outfit.style,
                                    userBudget: preferences.budget
                                )

                                HStack(spacing: 16) {

                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color("SurfaceLow"))
                                            .frame(width: 56, height: 56)

                                        Image(item.type)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 52, height: 52)
                                    }

                                    VStack(alignment: .leading, spacing: 6) {

                                        Text(item.type.capitalized)
                                            .font(.custom("Manrope-SemiBold", size: 16))

                                        Text(itemDescription(item))
                                            .font(.custom("Manrope-Regular", size: 13))
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    if let store = store {
                                        Button {
                                            openSearchForItem(
                                                store: store,
                                                item: item
                                            )
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

            } else {

                ProgressView("Generating Outfit...")
            }
        }
        .onAppear {

            guard selectedOutfit == nil else {
                return
            }

            selectedOutfit =
                engine
                    .getBestOutfits(
                        preferences: preferences
                    )
                    .first
        }
    }
}

// MARK: - HELPERS
extension OutfitView {

    func openSearchForItem(
        store: Store,
        item: OutfitItem
    ) {

        var parts:[String] = []

        // color
        if let color = item.color {
            parts.append(color)
        }

        // normalize style
        var searchStyle = ""

        if let style = item.style {

            switch style.lowercased() {

            case "tailored":
                searchStyle = "work"

            case "bodycon":
                searchStyle = "fitted"

            case "oversized":
                searchStyle = "relaxed"

            case "wide_leg":
                searchStyle = "wide leg"

            case "straight_leg":
                searchStyle = "straight"

            case "cropped":
                searchStyle = "cropped"

            case "minimal":
                searchStyle = "minimal"

            default:
                searchStyle = style
                    .replacingOccurrences(
                        of: "_",
                        with: " "
                    )
            }
        }

        if !searchStyle.isEmpty {
            parts.append(searchStyle)
        }

        // clean item type
        let cleanType: String

        switch item.type {

        case "tshirt":
            cleanType = "t-shirt"

        case "tank_top":
            cleanType = "tank top"

        case "crossbody_bag":
            cleanType = "crossbody bag"

        case "shoulder_bag":
            cleanType = "shoulder bag"

        case "tote_bag":
            cleanType = "tote bag"

        case "gym_bag":
            cleanType = "gym bag"

        default:
            cleanType = item.type
                .replacingOccurrences(
                    of: "_",
                    with: " "
                )
        }

        parts.append(cleanType)

        let query = parts.joined(separator: " ")

        let encodedQuery =
            query.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) ?? ""

        let urlString = store.search_template
            .replacingOccurrences(
                of: "{query}",
                with: encodedQuery
            )

        print("SHOP URL:")
        print(urlString)

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    func itemDescription(
        _ item: OutfitItem
    ) -> String {

        var parts:[String] = []

        if let color = item.color {
            parts.append(color)
        }

        if let fit = item.fit {
            parts.append(fit)
        }

        if let style = item.style {
            parts.append(style)
        }

        if let material = item.material {
            parts.append(material)
        }

        return parts.joined(
            separator: " "
        )
    }
}
