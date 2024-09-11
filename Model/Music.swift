//
//  Music.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import Foundation

//structs to read in music information from the API
struct Auth : Codable {
    let access_token: String
}

struct MusicList : Codable, Hashable {
    let albums: MusicItem
}

struct MusicItem : Codable, Hashable {
    let items: [Album]
}

struct Album : Codable, Hashable, Identifiable {
    let id: String
    let images: [ImageUrl]
    let name: String
    let type: String
    let artists: [Artist]
}

struct ImageUrl : Codable, Hashable {
    let url: String
}

struct Artist : Codable, Hashable {
    let name: String
}
