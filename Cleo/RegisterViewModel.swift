import Foundation
import FirebaseAuth
import Combine


class RegisterViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var errorMessage: String?
    @Published var isEmailSent = false
    
    func register() {
        errorMessage = nil
        
        // Validation
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        // Firebase create user
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            // Send verification email
            result?.user.sendEmailVerification { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                DispatchQueue.main.async {
                    self.isEmailSent = true
                }
            }
        }
    }
}
