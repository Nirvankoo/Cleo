import Foundation
import Combine
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    @Published var user: User?
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}
