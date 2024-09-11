//
//  BookSearchView.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import SwiftUI

//this shows information about Book objects that are found by searching the API for certain search terms
//this view creates a cell for a single Book so it can be displayed with others in a list on the InsertPage
struct BookSearchView: View {
    let book: Book
    @EnvironmentObject var lists: MyLists
    @State var iconName: String = "plus"

    var body: some View {
        HStack{
            Button(action: {
                lists.newItem = MyInfo(id: UUID(), title: book.volumeInfo.title, author: book.volumeInfo.authors[0], notes: "", labels: ["Book"], cover: book.volumeInfo.getLink(), type: 0)
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
                Text(book.volumeInfo.title)
                Text(book.volumeInfo.authors[0])
                    .font(.caption)
            }
        }
    }
}
