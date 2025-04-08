//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 22/03/25.
//

struct AllCharacterDTO: Codable {
    let info: AllCharacterInfoDTO
    let results: [CharacterResultDTO]
}

// MARK: - Characater Info
struct AllCharacterInfoDTO: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Character Result
struct CharacterResultDTO: Codable {
    let id: Int
    let name: String
    let status, species, type: String?
    let gender: String?
    let origin, location: CharacterLocationDTO?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

// MARK: - Location
struct CharacterLocationDTO: Codable {
    let name: String
    let url: String
}

// MARK: - Info To Domain Entity
extension AllCharacterInfoDTO {
    func toDomain() -> PaginationInfoEntity {
        return .init(
            count: count,
            pages: pages,
            next: next ?? "",
            prev: prev ?? "")
    }
}

// MARK: - Character To Domain Entity
extension CharacterResultDTO {
    func toDomain() -> CharacterEntity {
        return .init(
            id: id,
            name: name,
            image: image ?? "",
            species: species ?? "",
            placed: origin?.name ?? "")
    }
}

// MARK: - AllCharacter To Domain Entity
extension AllCharacterDTO {
    func toDomain() -> AllCharacterResponseEntity {
        return .init(
            info: info.toDomain(),
            characters: results.map { $0.toDomain() })
    }
}
