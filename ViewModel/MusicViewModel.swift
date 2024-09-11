//
//  MusicViewModel.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/10/24.
//

import Foundation

//calls Spotify API to search for albums
class MusicViewModel: ObservableObject {
    @Published var searchResults: MusicList = MusicList(albums: MusicItem(items: []))
    var auth = Auth(access_token: "")
    var accessToken = ""
    let clientID = "" //specific clientID removed
    let clientSecret = "" //specific clientSecret removed
    
    //searches given search terms from the InsertPage
    func search(terms: String) async {
        let urlAuth = URL(string: "https://accounts.spotify.com/api/token?")! //edited for account security
        var requestAuth = URLRequest(url: urlAuth)
        requestAuth.setValue("Basic", forHTTPHeaderField: "Authorization") //edited for account security
        requestAuth.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestAuth.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.data(for: requestAuth)
            let decoderAuth = JSONDecoder()
            auth = try decoderAuth.decode(Auth.self, from: data)
            accessToken = auth.access_token
        } catch {
            print(error)
        }
        
        let url = URL(string: "https://api.spotify.com/v1/search?q=\(terms)&type=album,track&limit=10")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            //decodes JSON data from API into a list
            searchResults = try decoder.decode(MusicList.self, from: data)
            
        } catch {
            print(error)
        }
    }
}
