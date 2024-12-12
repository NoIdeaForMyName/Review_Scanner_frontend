//
//  LoginViewModel.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 12/12/2024.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoggedIn: Bool = false
    @Published public var errorMessage: String? // Do przechowywania błędów logowania

    private var loginCancellable: AnyCancellable? // Do przechowywania subskrypcji

    public func loginAction() {
        errorMessage = nil // Wyczyść poprzedni błąd

        loginCancellable = environmentData.authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Login completed successfully")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] userData in // TODO
                environmentData.userData.email = userData.email
                environmentData.userData.nickname = userData.nickname
                self?.isLoggedIn = true

            })
    }
    
}
