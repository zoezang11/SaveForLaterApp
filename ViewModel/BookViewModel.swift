//
//  BookViewModel.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import Foundation

//calls Google Books API to search for books
class BookViewModel: ObservableObject {
    @Published var searchResults: BookList = BookList(items: [])
    let apiKey = "" //specific API key removed
        
    //searches given search terms from the InsertPage
    func search(terms: String) async {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(terms)&projection=lite&maxResults=10")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            searchResults = try decoder.decode(BookList.self, from: data) //decodes JSON data from API into a list
            
        } catch {
            print(error)
        }
    }
}
