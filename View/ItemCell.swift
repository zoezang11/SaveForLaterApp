//
//  ItemCell.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import SwiftUI
import Kingfisher

//ItemCell shows the cover and information for each piece of media
//the ItemCells are displayed in the Book/Movie/MusicListPages in the grid
//when clicked, the ItemDetailPage for the specific media entry is opened
struct ItemCell: View {
    let item: MyInfo
    let itemType: Int
    let setHeight: CGFloat = 240
    let setWidth: CGFloat = 160
    
    @State var foundImage = false
    
    var height : CGFloat { //display rectangle images for movies/books and square images for music
        if(itemType == 2){
            return 160
        }
        else {
            return 240
        }
    }
    
    //edit image urls provided by the different APIs as needed to get the images to display
    func editString(s: String) -> String {
        var newS = s
        if(itemType == 0){
            newS += "&fife=w800"
        }
        let i = s.firstIndex(of: "/")
        if let endOfSentence = s.firstIndex(of: ":"){
            return "https\(newS[endOfSentence...])"
        }
        else if i != nil && i == s.startIndex {
            return "https://image.tmdb.org/t/p/w500/" + newS
        }
        else {
            return ""
        }
    }
    
    
    var body: some View {
        NavigationLink(value: item) {
            ZStack(alignment: .bottomLeading) {
                if let c = item.cover { //if item.cover isn't null, want to load photo from api url
                    let s = editString(s: c)

                    if let url = URL(string: s) { //resize & format image
                        KFImage(url)
                            .resizable()
                            .frame(width: setWidth, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    else { //if item.cover isn't null but the image isn't found for some reason, display default image
                        NoImage(height: height, setHeight: setHeight, setWidth: setWidth)
                    }
                }
                else if let customPhoto = item.photo { //want to load photo from photos -- for custom entries
                    if let img = customPhoto.getImage() {
                        Image(uiImage: img)
                            .resizable() //resize image as needed
                            .frame(width: setWidth, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    else { //if image isn't found for some reason, display default image
                        NoImage(height: height, setHeight: setHeight, setWidth: setWidth)
                    }
                } else { //no image found -- display default image
                    NoImage(height: height, setHeight: setHeight, setWidth: setWidth)
                }
                VStack(alignment: .center){ //item info: title and author
                    Text(item.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                    Text(item.author)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(4)
                .background(Color.white)
                .opacity(0.8)
                .font(.caption)
            }
            .frame(width: setWidth, height: height)
        }
    }
}

//show a placeholder image if no image is found
struct NoImage: View {
    let height: CGFloat
    let setHeight: CGFloat
    let setWidth: CGFloat
    
    var body: some View {
        if height == setHeight {
            Image("NoImage2")
                .resizable()
                .frame(width: setWidth, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        else {
            Image("NoImage3")
                .resizable()
                .frame(width: setWidth, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
