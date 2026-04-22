import Foundation
import FirebaseAuth
import Combine

class RegisterViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isEmailSent = false
    
    func register() {
        errorMessage = nil
        
        guard !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            result?.user.sendEmailVerification { error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else {
                        self?.isEmailSent = true
                        try? Auth.auth().signOut()
                    }
                }
            }
        }
    }
}
