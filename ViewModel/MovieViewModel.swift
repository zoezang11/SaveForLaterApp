//
//  MovieViewModel.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/11/24.
//

import Foundation

//calls The Movie Database API to search for movies
class MovieViewModel: ObservableObject {
    @Published var searchResults: MovieList = MovieList(results: [])
    @Published var searchResultsTV: TVList = TVList(results: [])
    let apiKey = "" //specific API key removed
    
    //searches for movies given search terms from the InsertPage
    func search(terms: String) async {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(terms)&language=en-US&page=1")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": apiKey
        ]
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            //decodes JSON data to store in a list
            searchResults = try decoder.decode(MovieList.self, from: data)
            
        } catch {
            print(error)
        }
    }
    
    //searches for shows given search terms from the InsertPage
    func searchTV(terms: String) async {
        let url = URL(string: "https://api.themoviedb.org/3/search/tv?query=\(terms)&language=en-US&page=1")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": apiKey
        ]
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            //decodes JSON data to store in a list
            searchResultsTV = try decoder.decode(TVList.self, from: data)
            
        } catch {
            print(error)
        }
    }
}
