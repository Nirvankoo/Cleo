import Foundation
import FirebaseAuth
import FirebaseCore
import Combine
import AuthenticationServices
import GoogleSignIn
import UIKit

import CryptoKit

class AuthManager: ObservableObject {

    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var authListener: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?

    init() {
        listenToAuthState()
    }

    private func listenToAuthState() {
        authListener = Auth.auth().addStateDidChangeListener { _, firebaseUser in
            
            DispatchQueue.main.async {
                if let firebaseUser = firebaseUser {
                    self.currentUser = User(
                        id: firebaseUser.uid,
                        email: firebaseUser.email ?? "",
                        isEmailVerified: firebaseUser.isEmailVerified
                    )
                } else {
                    self.currentUser = nil
                }
            }
        }
    }

    // MARK: - Email Login
    func signIn(email: String, password: String) {
        
        if isLoading { return }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Please enter email and password"
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        Auth.auth().signIn(withEmail: trimmedEmail, password: trimmedPassword) { _, error in
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error as NSError? {
                    
                    switch error.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        self.errorMessage = "Incorrect password"
                    case AuthErrorCode.userNotFound.rawValue:
                        self.errorMessage = "User not found"
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.errorMessage = "Invalid email format"
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    
                    print("❌ Login failed:", error.localizedDescription)
                    return
                }
                
                print("✅ Login successful")
            }
        }
    }

    // MARK: - Google Sign-In
    func signInWithGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Missing clientID")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController else {
            print("❌ No root view controller")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                print("❌ Google Sign-In error:", error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ Missing Google user/token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        print("❌ Firebase Google auth error:", error.localizedDescription)
                        return
                    }
                    
                    print("✅ Google login success")
                }
            }
        }
    }

    // MARK: - Apple Sign-In (placeholder for now)
    func handleAppleSignIn(request: ASAuthorizationAppleIDRequest) {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }

    func handleAppleCompletion(result: Result<ASAuthorization, Error>) {
        
        switch result {
            
        case .success(let authResults):
            
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else {
                print("❌ Unable to get Apple credential")
                return
            }
            
            guard let nonce = currentNonce else {
                print("❌ Missing nonce")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("❌ Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("❌ Unable to serialize token")
                return
            }
            
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName
            )
            
            Auth.auth().signIn(with: credential) { _, error in
                
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        print("❌ Apple Sign-In error:", error.localizedDescription)
                        return
                    }
                    
                    print("✅ Apple login success")
                }
            }
            
        case .failure(let error):
            print("❌ Apple Sign-In failed:", error.localizedDescription)
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                SecRandomCopyBytes(kSecRandomDefault, 1, &random)
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

    // MARK: - Reset Password
    func resetPassword(email: String) {
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Enter your email first"
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        Auth.auth().sendPasswordReset(withEmail: trimmedEmail) { error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.errorMessage = "Password reset email sent"
                }
            }
        }
    }

    // MARK: - Logout
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Sign out error:", error.localizedDescription)
        }
    }
}
