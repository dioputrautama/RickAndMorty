//
//  GetAllCharacterUseCase.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 03/04/25.
//

protocol GetAllCharacterUseCaseProtocol {
    func getAllCharacter(page: Int) async throws -> AllCharacterResponseEntity
}

final class GetAllCharacterUseCase: GetAllCharacterUseCaseProtocol {
    private let repository: GetAllCharacterRepositoryProtocol

    init(repository: GetAllCharacterRepositoryProtocol = GetAllCharacterRepository()) {
        self.repository = repository
    }
}

extension GetAllCharacterUseCase {
    func getAllCharacter(page: Int) async throws -> AllCharacterResponseEntity {
        return try await repository.getAllCharacter(page: page)
    }
}
