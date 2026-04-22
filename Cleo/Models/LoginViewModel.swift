import Foundation
import Combine
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

import AuthenticationServices
import CryptoKit
import UIKit

class LoginViewModel: ObservableObject {
    
    // MARK: - State
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var email = ""
    @Published var password = ""
    
    private var currentNonce: String?
    
    // MARK: - Email Login
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let user = result?.user else { return }
            
            // 🔴 IMPORTANT: check verification
            user.reload { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    // 🔴 IMPORTANT: get UPDATED user
                    guard let refreshedUser = Auth.auth().currentUser else { return }
                    
                    if !refreshedUser.isEmailVerified {
                        self.errorMessage = "Please verify your email first"
                        try? Auth.auth().signOut()
                        return
                    }
                    
                    // ✅ NOW it will work correctly
                }
            }
        }
    }
    
    // MARK: - Google Sign-In
    func signInWithGoogle() {
        
        // Prevent stale session issues
        GIDSignIn.sharedInstance.signOut()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Missing Firebase client ID"
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let rootVC = getRootViewController() else {
            errorMessage = "Unable to get root view controller"
            return
        }
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let user = result?.user else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Failed to get Google user"
                }
                return
            }
            
            guard let idToken = user.idToken?.tokenString else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Failed to get ID token"
                }
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { [weak self] _, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error?.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Apple Sign-In
    func handleAppleSignIn(request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }
    
    func handleAppleCompletion(result: Result<ASAuthorization, Error>) {
        
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
            
        case .success(let authResults):
            
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else {
                return
            }
            
            guard let nonce = currentNonce else {
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                return
            }
            
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName
            )
            
            isLoading = true
            
            Auth.auth().signIn(with: credential) { [weak self] _, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error?.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            return nil
        }
        return root
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.map { String(format: "%02x", $0) }.joined()
    }
    
    func resetPassword() {
        
        guard !email.isEmpty else {
            errorMessage = "Enter your email first"
            return
        }
        
        isLoading = true
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.errorMessage = "Password reset email sent"
                }
            }
        }
    }
}
