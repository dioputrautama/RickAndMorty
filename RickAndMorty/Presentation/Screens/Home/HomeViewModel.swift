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
    @Published var allCharacterState: HomeViewState<[CharacterEntity]> = .loading
    private let getAllCharacterUseCase: GetAllCharacterUseCaseProtocol
    private var characters: [CharacterEntity] = []
    private var allCharacterPage: Int = 0

    init(getAllCharacterUseCase: GetAllCharacterUseCaseProtocol = GetAllCharacterUseCase()) {
        self.getAllCharacterUseCase = getAllCharacterUseCase
    }
}

extension HomeViewModel {

    // MARK: REQUEST GET ALL CHARACTERS
    func getAllCharacter() {
        allCharacterPage += 1

        if allCharacterPage > 1 {
            allCharacterState = .success(data: characters, loadMore: true)
        }

        Task {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                let result = try await getAllCharacterUseCase.getAllCharacter(page: allCharacterPage)
                loadCharacter(result.characters)
            } catch(let error) {
                allCharacterState = .error(message: error.localizedDescription)
                print("~ Error \(error.localizedDescription)")
            }
        }
    }

    func loadCharacter(_ data: [CharacterEntity]) {
        DispatchQueue.main.async {
            self.characters.append(contentsOf: data)
            self.allCharacterState = .success(data: self.characters, loadMore: false)
        }
    }
}
