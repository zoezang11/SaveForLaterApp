//
//  MusicSearchView.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/11/24.
//

import SwiftUI

//this shows information about Music objects that are found by searching the API for certain search terms
//this view creates a cell for a single Music object so it can be displayed with others in a list on the InsertPage
struct MusicSearchView: View {
    let album: Album
    @EnvironmentObject var lists: MyLists
    @State var iconName: String = "plus"
    
    var body: some View {
        HStack{
            Button(action: {
                lists.newItem = MyInfo(id: UUID(), title: album.name, author: album.artists[0].name, notes: "", labels: ["Music"], cover: album.images[0].url, type: 2)
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
                Text(album.name)
                Text(album.artists[0].name)
                    .font(.caption)
            }
        }
    }
}
