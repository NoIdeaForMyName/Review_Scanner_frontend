import SwiftUI

struct RegisterView: View {
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    
    var body: some View {
        VStack(spacing: 80) {
            Text("Create new account")
            
            VStack(spacing: 25) {
                VStack(spacing: 20) {
                    HStack {
                        Text("Nickname")
                            .frame(width: 85, alignment: .leading)
                        TextField("Enter your nickname", text: $nickname)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .textInputAutocapitalization(.none)
                            .autocorrectionDisabled(true)
                    }
                    
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
                    
                    HStack {
                        Text("Repeat")
                            .frame(width: 85, alignment: .leading)
                        SecureField("Repeat your password", text: $repeatedPassword)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                
                Button(action: {
                    // TODO: add register action
                }) {
                    Text("Register")
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
    }
}



#Preview {
    RegisterView()
}
