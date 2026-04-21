import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @StateObject private var vm = LoginViewModel()
    
   
    
    private var isLoginDisabled: Bool {
        vm.isLoading ||
        vm.email.trimmingCharacters(in: .whitespaces).isEmpty ||
        vm.password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 22) { // ⬅️ Step 3: reduced spacing from 28 → 22
                
                // MARK: - Brand
                Text("CLEO")
                    .font(.custom("Manrope-SemiBold", size: 14))
                    .tracking(4)
                    .foregroundColor(Color("TextPrimary"))
                
                Image("login_model")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color("AppBackground")]),
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
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("EMAIL")
                            .font(.custom("Manrope-Medium", size: 10))
                            .tracking(1.5)
                            .foregroundColor(.gray)
                        
                        TextField(
                            "",
                            text: $vm.email,
                            prompt: Text("your@email.com")
                                .foregroundStyle(Color("OutlineVariant").opacity(0.6))
                        )
                        .font(.custom("Manrope-Regular", size: 16))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .tint(Color("TextPrimary"))
                        .padding(.vertical, 8)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color("OutlineVariant").opacity(0.4)),
                            alignment: .bottom
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("PASSWORD")
                                .font(.custom("Manrope-Medium", size: 10))
                                .tracking(1.5)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("FORGOT?")
                                .font(.custom("Manrope-Regular", size: 10))
                                .foregroundColor(.gray)
                        }
                        
                        SecureField("••••••••", text: $vm.password)
                            .font(.custom("Manrope-Regular", size: 16))
                            .padding(.vertical, 8)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("OutlineVariant").opacity(0.4)),
                                alignment: .bottom
                            )
                    }
                }
                
                // MARK: - Login Button
                Button {
                    vm.login()
                } label: {
                    if vm.isLoading {
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
                .background(Color("Primary"))
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
                            .foregroundColor(Color("Primary"))
                    }
                }
                
                // MARK: - Socials (Step 2 + 4 applied)
                VStack(spacing: 12) { // ⬅️ Step 2: grouped tightly
                    
                    Button {
                        vm.signInWithGoogle()
                    } label: {
                        HStack(spacing: 10) {
                            
                            Image("google_icon")
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Text("Continue with Google")
                                .font(.custom("Manrope-Medium", size: 14))
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // 👈 key line
                        .padding()
                    }
                    .background(Color.white)
                    .foregroundColor(Color("TextPrimary"))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color("OutlineVariant").opacity(0.4), lineWidth: 1)
                    )
                    .disabled(vm.isLoading)
                    
                    SignInWithAppleButton(
                        onRequest: { request in
                            vm.handleAppleSignIn(request: request)
                        },
                        onCompletion: { result in
                            vm.handleAppleCompletion(result: result)
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .clipShape(Capsule())
                    .disabled(vm.isLoading)
                }
                .padding(.top, 10) // ⬅️ Step 4: controlled spacing instead of Spacer
                
                // MARK: - Errors
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.custom("Manrope-Regular", size: 13))
                        .multilineTextAlignment(.center)
                }
                
                Spacer() // ⬅️ keep ONLY this one
            }
            .padding(.horizontal, 24)
            .background(Color("AppBackground"))
        }
    }
}

