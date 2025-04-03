//
//  CharacterEntity.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 22/03/25.
//

struct AllCharacterResponseEntity {
    let info: PaginationInfoEntity
    let characters: [CharacterEntity]
}

struct PaginationInfoEntity {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
