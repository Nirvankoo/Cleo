import SwiftUI

struct SavedOutfitDetailView: View {

    let outfit: Outfit
    let userBudget: Double

    @EnvironmentObject var savedOutfitManager: SavedOutfitManager

    @StateObject private var engine = OutfitEngine()

    var body: some View {

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

                // MARK: - Saved Button

                HStack(spacing: 8) {

                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)

                    Text("Saved")
                }
                .font(.custom("Manrope-SemiBold", size: 15))
                .foregroundColor(.green)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color("CleoPrimary"))
                .cornerRadius(14)

                // MARK: - Header

                VStack(alignment: .leading, spacing: 4) {

                    Text("Items in this Outfit")
                        .font(.custom("Manrope-SemiBold", size: 18))

                    Text("Curated pieces for a cohesive aesthetic.")
                        .font(.custom("Manrope-Regular", size: 13))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: - Item Cards

                VStack(spacing: 10) {
                    let primaryStore = engine.getPrimaryStore(
                        for: outfit,
                        userBudget: userBudget
                    )
                    ForEach(outfit.items, id: \.type) { item in

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

                            VStack(
                                alignment: .leading,
                                spacing: 6
                            ) {

                                Text(item.type.capitalized)
                                    .font(
                                        .custom(
                                            "Manrope-SemiBold",
                                            size: 16
                                        )
                                    )

                                Text(itemDescription(item))
                                    .font(
                                        .custom(
                                            "Manrope-Regular",
                                            size: 13
                                        )
                                    )
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            if let store = engine.getStoreForItem(
                                item,
                                style: outfit.style,
                                userBudget: userBudget,
                                primaryStore: primaryStore
                            ) {

                                Button {

                                    openSearchForItem(
                                        store: store,
                                        item: item
                                    )

                                } label: {

                                    Text("Shop Now")
                                        .font(
                                            .custom(
                                                "Manrope-Medium",
                                                size: 13
                                            )
                                        )
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
        .navigationTitle("Outfit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Helpers

extension SavedOutfitDetailView {

    func itemDescription(
        _ item: OutfitItem
    ) -> String {

        var parts: [String] = []

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

        return parts.joined(separator: " ")
    }
    
    func openSearchForItem(
        store: Store,
        item: OutfitItem
    ) {

        var parts:[String] = []

        if let color = item.color {
            parts.append(color)
        }

        var searchStyle = ""

        if let style = item.style {

            switch style.lowercased() {

            case "tailored":
                searchStyle = "work"

            case "bodycon":
                searchStyle = "fitted"

            case "oversized":
                searchStyle = "oversized"

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

        let cleanType =
            item.type.replacingOccurrences(
                of: "_",
                with: " "
            )

        parts.append(cleanType)

        let query = parts.joined(separator: " ")

        let encodedQuery =
            query.addingPercentEncoding(
                withAllowedCharacters:
                    .urlQueryAllowed
            ) ?? ""

        let urlString =
            store.search_template
                .replacingOccurrences(
                    of: "{query}",
                    with: encodedQuery
                )

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
