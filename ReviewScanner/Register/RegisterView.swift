import SwiftUI

struct RegisterView: View {
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    
    @EnvironmentObject var environmentData: EnvironmentData
    
    @StateObject var registerViewModel: RegisterViewModel = RegisterViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 80) {
                Text("Create new account")
                
                VStack(spacing: 25) {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Nickname")
                                .frame(width: 85, alignment: .leading)
                            TextField("Enter your nickname", text: $registerViewModel.nickname)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                                .textInputAutocapitalization(.none)
                                .autocorrectionDisabled(true)
                        }
                        
                        HStack {
                            Text("E-mail")
                                .frame(width: 85, alignment: .leading)
                            TextField("Enter your e-mail address", text: $registerViewModel.email)
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
                            SecureField("Enter your password", text: $registerViewModel.password)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("Repeat")
                                .frame(width: 85, alignment: .leading)
                            SecureField("Repeat your password", text: $registerViewModel.repeatedPassword)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    
                    if let errorMessage = registerViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    
                    
                    Button(action: {
                        registerViewModel.registerAction(environmentData: environmentData)
                    }) {
                        Text("Register")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.button)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .navigationDestination(isPresented: $registerViewModel.isLoggedIn) {
                        HomeView()
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
            
            if registerViewModel.isLoading {
                CircleLoaderView()
            }
        }
    }
}



#Preview {
    RegisterView()
}
