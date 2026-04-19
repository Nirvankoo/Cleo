import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @StateObject private var vm = LoginViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    private var isLoginDisabled: Bool {
        vm.isLoading ||
        email.trimmingCharacters(in: .whitespaces).isEmpty ||
        password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                vm.login(email: email, password: password)
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isLoginDisabled ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isLoginDisabled)
            
            Button(action: {
                vm.signInWithGoogle()
            }) {
                Text("Sign in with Google")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(vm.isLoading)
            
            
            
            if vm.isLoading {
                ProgressView()
            }
            
            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
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
            .cornerRadius(10)
            .disabled(vm.isLoading)
            
            
            
            Spacer()
        }
        .padding()
    }
}
