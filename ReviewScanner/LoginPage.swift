import SwiftUI

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
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
                
                Button(action: {
                    // TODO: add navigation to register view
                }) {
                    Text("Do not have an account? Create new.")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .underline()
                }
                
                Button(action: {
                    // TODO: add login action
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
        .padding(.top, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
    }
}



#Preview {
    LoginPage()
}
