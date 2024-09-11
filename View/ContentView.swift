//
//  ContentView.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/6/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var myLists: MyLists = MyLists()
    
    var body: some View {
        //navigation for different pages
        NavigationStack{
            TabView {
                InsertPage()
                    .tabItem {
                        Label("Insert", systemImage: "plus.app.fill")
                    }
                BookListPage()
                    .tabItem {
                        Label("Books", systemImage: "book.closed.fill")
                    }
                MovieListPage()
                    .tabItem {
                        Label("Movies & Shows", systemImage: "movieclapper")
                    }
                MusicListPage()
                    .tabItem {
                        Label("Music", systemImage: "music.note")
                    }
                FilterPage()
                    .tabItem {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                    }
            }
            .environmentObject(myLists)
            .tint(Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0))
            .navigationDestination(for: MyInfo.self){
                ItemDetailPage(item: $0)
                    .environmentObject(myLists)
            }
        }
        .tint(Color(red: 80/255.0, green: 137/255.0, blue: 145/255.0))
    }
}

#Preview {
    ContentView()
}
