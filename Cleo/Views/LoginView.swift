import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var authManager: AuthManager
    
    private var isLoginDisabled: Bool {
        authManager.isLoading ||
        email.trimmingCharacters(in: .whitespaces).isEmpty ||
        password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // MARK: - Background
                Color("AppBackground")
                    .ignoresSafeArea()
                
                VStack(spacing: 22) {
                    
                    Spacer()
                        .frame(height: 25)
                    
                    // MARK: - Brand
                    Text("CLEO")
                        .font(.custom("Manrope-SemiBold", size: 14))
                        .tracking(4)
                        .foregroundColor(Color("TextPrimary"))
                    
                    // MARK: - Hero Image
                    Image("login_model")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color("AppBackground")
                                ]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                    
                    // MARK: - Title
                    VStack(spacing: 6) {
                        
                        Text("Welcome to Cleo")
                            .font(.custom("Manrope-Regular", size: 28))
                            .foregroundColor(Color("TextPrimary"))
                        
                        Text("Curating your style journey.")
                            .font(.custom("Manrope-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    // MARK: - Inputs
                    VStack(spacing: 20) {
                        
                        // EMAIL
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("EMAIL")
                                .font(.custom("Manrope-Medium", size: 10))
                                .tracking(1.5)
                                .foregroundColor(.gray)
                            
                            TextField(
                                "",
                                text: $email,
                                prompt: Text("your@email.com")
                                    .foregroundStyle(
                                        Color("OutlineVariant").opacity(0.7)
                                    )
                            )
                            .font(.custom("Manrope-Regular", size: 16))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .tint(Color("TextPrimary"))
                            .padding(.vertical, 8)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(
                                        Color("OutlineVariant").opacity(0.4)
                                    ),
                                alignment: .bottom
                            )
                        }
                        
                        // PASSWORD
                        VStack(alignment: .leading, spacing: 6) {
                            
                            HStack {
                                
                                Text("PASSWORD")
                                    .font(.custom("Manrope-Medium", size: 10))
                                    .tracking(1.5)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button {
                                    authManager.resetPassword(email: email)
                                } label: {
                                    Text("FORGOT?")
                                        .font(.custom("Manrope-Regular", size: 10))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            SecureField("••••••••", text: $password)
                                .font(.custom("Manrope-Regular", size: 16))
                                .padding(.vertical, 8)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(
                                            Color("OutlineVariant").opacity(0.4)
                                        ),
                                    alignment: .bottom
                                )
                        }
                    }
                    
                    // MARK: - Login Button
                    Button {
                        authManager.signIn(
                            email: email,
                            password: password
                        )
                    } label: {
                        
                        if authManager.isLoading {
                            
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                        } else {
                            
                            Text("Log In")
                                .font(.custom("Manrope-Medium", size: 16))
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color("CleoPrimary"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .disabled(isLoginDisabled)
                    
                    // MARK: - Sign Up
                    HStack {
                        
                        Text("Don’t have an account?")
                            .foregroundColor(.gray)
                            .font(.custom("Manrope-Regular", size: 13))
                        
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Sign Up")
                                .font(.custom("Manrope-Medium", size: 13))
                                .foregroundColor(Color("CleoPrimary"))
                        }
                    }
                    
                    // MARK: - Social Buttons
                    VStack(spacing: 12) {
                        
                        // Google
                        Button {
                            authManager.signInWithGoogle()
                        } label: {
                            
                            HStack(spacing: 10) {
                                
                                Image("google_icon")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                
                                Text("Continue with Google")
                                    .font(.custom("Manrope-Medium", size: 14))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .background(Color.white)
                        .foregroundColor(Color("TextPrimary"))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(
                                    Color("OutlineVariant").opacity(0.4),
                                    lineWidth: 1
                                )
                        )
                        .disabled(authManager.isLoading)
                        
                        // Apple
                        SignInWithAppleButton(
                            onRequest: { request in
                                authManager.handleAppleSignIn(request: request)
                            },
                            onCompletion: { result in
                                authManager.handleAppleCompletion(result: result)
                            }
                        )
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 50)
                        .clipShape(Capsule())
                        .disabled(authManager.isLoading)
                    }
                    .padding(.top, 10)
                    
                    // MARK: - Error
                    if let error = authManager.errorMessage {
                        
                        Text(error)
                            .foregroundColor(.red)
                            .font(.custom("Manrope-Regular", size: 13))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
