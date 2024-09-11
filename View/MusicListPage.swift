//
//  MusicListPage.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/11/24.
//

import SwiftUI

//this page displays the cover, title, and artist for albums added to the myMusic list
struct MusicListPage: View {
    let colorLightBlue = Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0)
    
    @EnvironmentObject var myLists: MyLists
    let items: [GridItem] = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100)),
    ]
    
    var body: some View {
        VStack {
            HStack{
                Text("Music") //title
                    .font(.system(size: 38, weight: .bold, design: .serif))
                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                    .padding(.top, 16)
            }
            RoundedRectangle(cornerRadius: 5)
                .fill(colorLightBlue)
                .frame(height: 4)
                .padding(.bottom, 8)
            ScrollView(.vertical){ //grid of items
                LazyVGrid(columns: items, alignment: .center, spacing: 10){
                    ForEach(myLists.myMusic) { item in
                        ItemCell(item: item, itemType: 2)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MusicListPage()
        .environmentObject(MyLists())
}
