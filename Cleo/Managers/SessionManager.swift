import Foundation
import FirebaseAuth
import Combine

class SessionManager: ObservableObject {
    
    @Published var user: User?
    
    init() {
        listen()
    }
    
    private func listen() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            
            guard let user = user else {
                DispatchQueue.main.async {
                    self?.user = nil
                }
                return
            }
            
            // 🔴 Refresh user to get latest verification state
            user.reload { _ in
                DispatchQueue.main.async {
                    self?.user = user
                }
            }
        }
    }
    
    var isLoggedIn: Bool {
        guard let user = user else { return false }
        return user.isEmailVerified
    }
}
