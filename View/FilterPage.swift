//
//  FilterPage.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/27/24.
//

import SwiftUI

//allows user to filter items by different labels that were added
struct FilterPage: View {
    let colorLightBlue = Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0)
    let colorTeal = Color(red: 80/255.0, green: 137/255.0, blue: 145/255.0)
    
    @EnvironmentObject var myLists: MyLists
    @State private var labelOne = 0
    @State private var labelTwo = 0
    @State private var typeSelected = 0
    @State var displayItems: [MyInfo]? = nil
    @State private var deleteLabel = 1
    
    let items: [GridItem] = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100)),
    ]
    
    var body: some View {
        VStack {
            Text("Filter")
                .font(.system(size: 38, weight: .bold, design: .serif))
                .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                .padding(.top, 16)
            RoundedRectangle(cornerRadius: 5)
                .fill(colorLightBlue)
                .frame(height: 4)
                .padding(.bottom, 8)
            HStack {
                Picker("Type", selection: $typeSelected){
                    Text("Book").tag(0)
                    Text("Movie/Show").tag(1)
                    Text("Music").tag(2)
                }
                .frame(minWidth: 80)
                //select up to two labels using pickers
                //referenced for ForEach loop: https://www.hackingwithswift.com/forums/swiftui/compiler-warning-non-constant-range-argument-must-be-an-integer-literal/14878
                Picker("Label", selection: $labelOne){
                    ForEach(0..<myLists.filters.count, id: \.self){ index in
                        Text(myLists.filters[index]).tag(index)
                    }
                }
                .frame(minWidth: 80)
                Picker("Label", selection: $labelTwo){
                    ForEach(0..<myLists.filters.count, id: \.self){ index in
                        Text(myLists.filters[index]).tag(index)
                    }
                }
                .frame(minWidth: 80)
            }
            Button("Filter"){
                displayItems = myLists.sort(type: typeSelected, one: myLists.filters[labelOne], two: myLists.filters[labelTwo])
            }
            .padding(12)
            .tint(Color.white)
            .bold()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorTeal)
            )
            ScrollView(.vertical){
                if let displayItems {
                    LazyVGrid(columns: items, alignment: .center, spacing: 10){
                        ForEach(displayItems) { item in
                            ItemCell(item: item, itemType: item.type)
                        }
                    }
                } else {
                    Text("Filter to display results")
                }
            }
            HStack{
                //allow user to delete labels from overall list
                Picker("Delete", selection: $deleteLabel){
                    ForEach(1..<myLists.filters.count, id: \.self){ index in
                        Text(myLists.filters[index]).tag(index)
                    }
                }
                .frame(minWidth: 80)
                Button(action: {
                    labelOne = 0
                    labelTwo = 0
                    myLists.removeLabelFromAll(label: myLists.filters[deleteLabel])
                    deleteLabel = 0
                }, label: {
                    Label("Delete From Filter List", systemImage: "delete.right.fill")
                })
                .tint(colorTeal)
            }
        }
        .padding()
    }
}
