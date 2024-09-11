//
//  MovieListPage.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/11/24.
//

import SwiftUI

//this page displays the cover, title, and year for movies added to the myMovies list
struct MovieListPage: View {
    let colorLightBlue = Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0)
    
    @EnvironmentObject var myLists: MyLists
    let items: [GridItem] = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100)),
    ]
    
    var body: some View {
        VStack {
            HStack{
                Text("Movies & Shows") //title
                    .font(.system(size: 38, weight: .bold, design: .serif))
                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                    .padding(.top, 16)
            }
            RoundedRectangle(cornerRadius: 5)
                .fill(colorLightBlue)
                .frame(height: 4)
                .padding(.bottom, 8)
            ScrollView(.vertical){ //grid of movies
                LazyVGrid(columns: items, alignment: .center, spacing: 10){
                    ForEach(myLists.myMovies) { item in
                        ItemCell(item: item, itemType: 0)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MovieListPage()
        .environmentObject(MyLists())
}
