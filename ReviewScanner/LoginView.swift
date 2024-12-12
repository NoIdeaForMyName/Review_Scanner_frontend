import SwiftUI
import Combine

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loginCancellable: AnyCancellable? // Do przechowywania subskrypcji
    @State private var errorMessage: String? // Do przechowywania błędów logowania

    var body: some View {
        NavigationStack {
            VStack(spacing: 80) {
                Text("Login to existing account")
                
                VStack(spacing: 25) {
                    VStack(spacing: 20) {
                        HStack {
                            Text("E-mail")
                                .frame(width: 85, alignment: .leading)
                            TextField("Enter your e-mail address", text: $email)
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
                            SecureField("Enter your password", text: $password)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    NavigationLink(destination: RegisterPage()) {
                        Text("Do not have an account? Create new.")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .underline()
                    }
                    
                    Button(action: {
                        loginAction()
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
            
            .navigationDestination(isPresented: $isLoggedIn) {
                HomePage()
            }
        }
    }

    private func loginAction() {
        errorMessage = nil // Wyczyść poprzedni błąd

        loginCancellable = environmentData.authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Login completed successfully")
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }, receiveValue: { userData in // TODO
                environmentData.userData.email = userData.email
                environmentData.userData.nickname = userData.nickname
                isLoggedIn = true
            })
    }
}



#Preview {
    LoginView()
}
