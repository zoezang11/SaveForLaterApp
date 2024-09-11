//
//  TV.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import Foundation

//structs to read in movie information from the API
struct MovieList : Codable, Hashable {
    let results: [Movie]
}

struct Movie : Codable, Hashable, Identifiable {
    let id: Int
    let poster_path: String?
    let release_date: String
    let title: String
}

struct TVList : Codable, Hashable {
    let results: [TV]
}

struct TV : Codable, Hashable, Identifiable {
    let id: Int
    let original_name: String
    let poster_path: String?
    let first_air_date: String
}

extension Movie { //extension to format date of movies -- just get year
    func date() -> String {
        if let i = release_date.firstIndex(of: "-") {
            return String(release_date[release_date.startIndex..<i])
        }
        else {
            return release_date
        }
    }
}

extension TV { //extension to format date of movies -- just get year
    func date() -> String {
        if let i = first_air_date.firstIndex(of: "-") {
            return String(first_air_date[first_air_date.startIndex..<i])
        }
        else {
            return first_air_date
        }
    }
}
