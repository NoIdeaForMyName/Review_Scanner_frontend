//
//  RegisterViewModel.swift
//  ReviewScanner
//
//  Created by m1 on 08/01/2025.
//
import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published public var nickname: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var repeatedPassword: String = ""
    @Published public var isLoggedIn: Bool = false
    @Published public var errorMessage: String? // Do przechowywania błędów logowania
    @Published public var isLoading: Bool = false

    private var registerCancellable: AnyCancellable? // Do przechowywania subskrypcji

    public func registerAction(environmentData: EnvironmentData) {
        var isOk = false
        
        if nickname.count < 2 {
            errorMessage = "Nickname too short"
        } else if email.count < 2 || !email.contains("@") {
            errorMessage = "Provide correct email"
        } else if password.count < 2 {
            errorMessage = "Password too short"
        } else if password != repeatedPassword {
            errorMessage = "Passwords do not match"
        } else {
            isOk = true
        }
        
        if isOk {
            errorMessage = nil // Wyczyść poprzedni błąd
            isLoading = true
            
            registerCancellable = environmentData.authService.register(email: email, password: password, nickname: nickname)
                .flatMap { [email, password] _ in  // Capture email and password in flatMap closure
                    environmentData.authService.login(email: email, password: password)
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Registration and login completed successfully")
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                    self?.isLoading = false
                }, receiveValue: { [weak self] userData in
                    environmentData.userData.email = userData.email
                    environmentData.userData.nickname = userData.nickname
                    self?.isLoggedIn = true
                })
                
        }
    }
    
}
