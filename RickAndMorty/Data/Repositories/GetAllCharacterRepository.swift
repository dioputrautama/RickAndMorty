//
//  GetAllCharacterRepository.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 03/04/25.
//

protocol GetAllCharacterRepositoryProtocol {
    func getAllCharacter(page: Int) async throws -> AllCharacterResponseEntity
}

final class GetAllCharacterRepository: GetAllCharacterRepositoryProtocol {
    private let networking: NetworkingProtocol

    init(networking: NetworkingProtocol = Networking()) {
        self.networking = networking
    }
}

extension GetAllCharacterRepository {
    func getAllCharacter(page: Int) async throws -> AllCharacterResponseEntity {
        let dto = try await networking.baseUrl(Constants.ApiConfig.baseUrl)
            .pathUrl("\(ApiPath.getAllCharacter.rawValue)?page=\(page)")
            .method(.get)
            .send(responseType: AllCharacterDTO.self)
        return dto.toDomain()
    }
}
