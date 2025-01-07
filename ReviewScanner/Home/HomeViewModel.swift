//
//  HomeViewModel.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 19/12/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published public var errorMessage: String? // Do przechowywania błędów logowania
    @Published public var logoutPerformed: Bool = false

    private var logoutCancellable: AnyCancellable? // Do przechowywania subskrypcji

    public func logoutAction(environmentData: EnvironmentData) {
        errorMessage = nil // Wyczyść poprzedni błąd

        logoutCancellable = environmentData.authService.logout()
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Logout completed successfully")
                    self?.logoutPerformed = true
                    environmentData.userData.clearData()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: {})
    }
    
}
