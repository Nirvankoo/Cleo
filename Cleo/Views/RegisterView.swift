import SwiftUI

struct RegisterView: View {
    
    @StateObject var vm = RegisterViewModel()
    
    private var isDisabled: Bool {
        vm.email.trimmingCharacters(in: .whitespaces).isEmpty ||
        vm.password.trimmingCharacters(in: .whitespaces).isEmpty ||
        vm.confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 22) {
            
            // MARK: - Title
            VStack(spacing: 6) {
                Text("Create Account")
                    .font(.custom("Manrope-Regular", size: 28))
                    .foregroundColor(Color("TextPrimary"))
                
                Text("Start your journey with Cleo.")
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
                    
                    ZStack(alignment: .leading) {
                        
                        if vm.email.isEmpty {
                            Text("your@email.com")
                                .foregroundColor(.gray.opacity(0.6))
                                .font(.custom("Manrope-Regular", size: 16))
                                .allowsHitTesting(false)
                        }
                        
                        TextField("", text: $vm.email)
                            .font(.custom("Manrope-Regular", size: 16))
                            .foregroundColor(Color("TextPrimary"))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .tint(Color("TextPrimary"))
                    }
                    .padding(.vertical, 8)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("OutlineVariant").opacity(0.4)),
                        alignment: .bottom
                    )
                }
                
                // PASSWORD
                VStack(alignment: .leading, spacing: 6) {
                    Text("PASSWORD")
                        .font(.custom("Manrope-Medium", size: 10))
                        .tracking(1.5)
                        .foregroundColor(.gray)
                    
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
                
                // CONFIRM PASSWORD
                VStack(alignment: .leading, spacing: 6) {
                    Text("CONFIRM PASSWORD")
                        .font(.custom("Manrope-Medium", size: 10))
                        .tracking(1.5)
                        .foregroundColor(.gray)
                    
                    SecureField("••••••••", text: $vm.confirmPassword)
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
            
            // MARK: - Register Button
            Button {
                vm.register()
            } label: {
                if vm.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Register")
                        .font(.custom("Manrope-Medium", size: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color("Primary"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .disabled(isDisabled || vm.isLoading)
            
            // MARK: - Messages
            
            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.custom("Manrope-Regular", size: 13))
                    .multilineTextAlignment(.center)
            }
            
            if vm.isEmailSent {
                Text("Verification email sent. Please check your inbox.")
                    .foregroundColor(.green)
                    .font(.custom("Manrope-Regular", size: 13))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color("AppBackground"))
    }
}
