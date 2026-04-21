import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .textFieldStyle(.roundedBorder)
            
            Button("Register") {
                viewModel.register()
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            if viewModel.isEmailSent {
                Text("Verification email sent. Please check your inbox.")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}
