import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 80) {
                    Text("Login to existing account")
                    
                    VStack(spacing: 25) {
                        VStack(spacing: 20) {
                            HStack {
                                Text("E-mail")
                                    .frame(width: 85, alignment: .leading)
                                TextField("Enter your e-mail address", text: $loginViewModel.email)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                                    .textInputAutocapitalization(.none)
                                    .autocorrectionDisabled(true)
                                    .keyboardType(.emailAddress)
                            }
                            
                            HStack {
                                Text("Password")
                                    .frame(width: 85, alignment: .leading)
                                SecureField("Enter your password", text: $loginViewModel.password)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        
                        if let errorMessage = loginViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Do not have an account? Create new.")
                                .font(.footnote)
                                .foregroundColor(.black)
                                .underline()
                        }
                        
                        Button(action: {
                            loginViewModel.loginAction(environmentData: environmentData)
                        }) {
                            Text("Login")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.button)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Gradient(colors: gradientColors))
                
                if loginViewModel.isLoading {
                    CircleLoaderView()
                }
            }
            .navigationDestination(isPresented: $loginViewModel.isLoggedIn) {
                HomeView()
            }
        }
    }

}



#Preview {
    LoginView()
}
