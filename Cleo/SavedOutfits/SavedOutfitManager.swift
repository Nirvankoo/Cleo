import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine

@MainActor
class SavedOutfitManager: ObservableObject {

    // MARK: - Published Properties

    @Published var savedOutfitIds: Set<String> = []
    @Published var savedOutfits: [SavedOutfit] = []

    // MARK: - Firebase

    private let ref = Database.database().reference()
    
    

    // MARK: - Save Outfit

    func saveOutfit(
        outfitId: String,
        budget: Double
    ){

        if savedOutfitIds.contains(outfitId) {
            print("ℹ️ Outfit already saved")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ Save failed: user not logged in")
            return
        }

        let values: [String: Any] = [
            "outfitId": outfitId,
            "budget": budget,
            "savedAt": ServerValue.timestamp()
        ]

        ref.child("users")
            .child(uid)
            .child("saved_outfits")
            .child(outfitId)
            .setValue(values) { error, _ in

                if let error = error {
                    print("❌ Save failed:", error.localizedDescription)
                    return
                }

                self.savedOutfitIds.insert(outfitId)

                print("✅ Outfit saved:", outfitId)
            }
    }
    
    // MARK: - Saved State

    func isSaved(_ outfitId: String) -> Bool {
        savedOutfitIds.contains(outfitId)
    }
    
    
    func savedOutfits(
        from allOutfits: [Outfit]
    ) -> [Outfit] {

        allOutfits.filter {
            savedOutfitIds.contains(
                $0.outfit_id
            )
        }
    }
    
    // MARK: - Load Saved Outfits

    func loadSavedOutfits() {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ Load failed: user not logged in")
            return
        }

        ref.child("users")
            .child(uid)
            .child("saved_outfits")
            .observeSingleEvent(of: .value) { snapshot in

                var loadedIds = Set<String>()
                var loadedOutfits: [SavedOutfit] = []

                for child in snapshot.children {

                    guard let snap = child as? DataSnapshot,
                          let dict = snap.value as? [String: Any],
                          let outfitId = dict["outfitId"] as? String,
                          let budget = dict["budget"] as? Double,
                          let savedAt = dict["savedAt"] as? Double else {
                        continue
                    }

                    loadedIds.insert(outfitId)

                    loadedOutfits.append(
                        SavedOutfit(
                            outfitId: outfitId,
                            budget: budget,
                            savedAt: savedAt
                        )
                    )
                }

                self.savedOutfitIds = loadedIds
                self.savedOutfits = loadedOutfits

                print("✅ Loaded \(loadedOutfits.count) saved outfits")
            }
    }
    
    func savedBudget(
        for outfitId: String
    ) -> Double {

        savedOutfits
            .first {
                $0.outfitId == outfitId
            }?
            .budget
            ?? 300
    }
    
    func removeSavedOutfit(
        outfitId: String
    ) {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ Remove failed: user not logged in")
            return
        }

        ref.child("users")
            .child(uid)
            .child("saved_outfits")
            .child(outfitId)
            .removeValue { error, _ in

                if let error = error {
                    print("❌ Remove failed:", error.localizedDescription)
                    return
                }

                self.savedOutfitIds.remove(outfitId)

                self.savedOutfits.removeAll {
                    $0.outfitId == outfitId
                }

                print("🗑️ Outfit removed:", outfitId)
            }
    }
    
  

}
