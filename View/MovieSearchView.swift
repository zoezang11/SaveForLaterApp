//
//  MovieSearchView.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/11/24.
//

import SwiftUI

//this shows information about Movie objects that are found by searching the API for certain search terms
//this view creates a cell for a single Movie object so it can be displayed with others in a list on the InsertPage
struct MovieSearchView: View {
    let movie: Movie
    @EnvironmentObject var lists: MyLists
    @State var iconName: String = "plus"

    var body: some View {
        HStack{
            Button(action: {
                lists.newItem = MyInfo(id: UUID(), title: movie.title, author: movie.date(), notes: "", labels: ["Movie"], cover: movie.poster_path, type: 1)
                iconName = "checkmark"
                
            }, label: {
                Label("", systemImage: iconName)
                    .padding([.leading], 8)
                    .padding([.bottom], 3)
                    .tint(Color.black)
                    .frame(width: 30, height: 30)
                    .background(Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0))
                    .clipShape(Circle())
                    
            })
            
            VStack(alignment: .leading){
                Text(movie.title)
                Text(movie.date())
                    .font(.caption)
            }
        }
    }
}

//stores info for TV shows
struct TVSearchView: View {
    let tv: TV
    @EnvironmentObject var lists: MyLists
    @State var iconName: String = "plus"

    var body: some View {
        HStack{
            Button(action: {
                lists.newItem = MyInfo(id: UUID(), title: tv.original_name, author: tv.date(), notes: "", labels: ["Show"], cover: tv.poster_path, type: 1)
                iconName = "checkmark"
                
            }, label: {
                Label("", systemImage: iconName)
                    .padding([.leading], 8)
                    .padding([.bottom], 3)
                    .tint(Color.black)
                    .frame(width: 30, height: 30)
                    .background(Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0))
                    .clipShape(Circle())
                    
            })
            
            VStack(alignment: .leading){
                Text(tv.original_name)
                Text(tv.date())
                    .font(.caption)
            }
        }
    }
}

