//
//  Book.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import Foundation

//structs to read in book information from the API
struct BookList : Codable, Hashable {
    let items: [Book]
}

struct Book : Codable, Hashable, Identifiable {
    let id: String
    let volumeInfo: Info
}

struct Info : Codable, Hashable {
    let title: String
    let authors: [String]
    let imageLinks: Cover?
}

struct Cover : Codable, Hashable {
    let thumbnail: String
}

extension Info {
    func getLink() -> String? {
        if let imageLinks {
            return imageLinks.thumbnail
        } else {
            return nil
        }
    }
}
