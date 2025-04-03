//
//  HomeVM.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 22/03/25.
//

import SwiftUI

protocol HomeViewModelProtocol: ObservableObject {
    func getAllCharacter()
}

final class HomeViewModel: HomeViewModelProtocol {
    private let getAllCharacterUseCase: GetAllCharacterUseCaseProtocol
    @Published var characters: [CharacterEntity] = []

    init(getAllCharacterUseCase: GetAllCharacterUseCaseProtocol = GetAllCharacterUseCase()) {
        self.getAllCharacterUseCase = getAllCharacterUseCase
    }
}

extension HomeViewModel {

    // MARK: GET ALL CHARACTERS
    func getAllCharacter() {
        Task {
            do {
                let result = try await getAllCharacterUseCase.getAllCharacter(page: 1)
                self.characters = result.characters
            } catch(let error) {
                print("~ Error \(error.localizedDescription)")
            }
        }
    }
}
