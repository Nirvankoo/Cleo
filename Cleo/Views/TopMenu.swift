import SwiftUI

struct TopMenu: View {

    @EnvironmentObject var authManager: AuthManager

    @State private var showProfile = false
    @State private var showSavedOutfits = false

    var body: some View {

        ZStack {

            Text("CLEO")
                .font(.custom("Manrope-SemiBold", size: 14))
                .tracking(4)

            HStack {

                Spacer()

                Button {
                    showProfile = true
                } label: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color("TextPrimary"))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)

        .sheet(isPresented: $showProfile) {

            VStack(spacing: 20) {

                Text("Profile")
                    .font(.title)

                Button {

                    showProfile = false

                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 0.25
                    ) {
                        showSavedOutfits = true
                    }

                } label: {

                    HStack {

                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)

                        Text("Saved Outfits")
                    }
                }

                Button {

                    authManager.signOut()

                } label: {

                    Text("Logout")
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
        }

        .sheet(isPresented: $showSavedOutfits) {

            SavedOutfitsView()
        }
    }
}
