//
//  Info.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import Foundation
import PhotosUI
import SwiftUI

//holds information for an item to be stored in MyLists
//stores information for items of any media type
class MyInfo : Identifiable, Hashable, Codable {
    var id: UUID
    var title: String
    var author: String
    var notes: String
    var labels: [String]
    var cover: String?
    var type: Int
    var photo: CodableImage?
    
    init(id: UUID, title: String, author: String, notes: String, labels: [String], cover: String? = nil, type: Int, photo: CodableImage? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.notes = notes
        self.labels = labels
        self.cover = cover
        self.type = type
        self.photo = photo
    }
    
    //check equals
    static func == (lhs: MyInfo, rhs: MyInfo) -> Bool {
        if(lhs.id == rhs.id){
            return true
        }
        else {
            return false
        }
    }
    
    //hash to conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(author)
        hasher.combine(notes)
        hasher.combine(labels)
        hasher.combine(cover)
        hasher.combine(type)
    }
    
    //setters
    func setTitle(newTitle: String){
        title = newTitle
    }
    
    func setAuthor(newAuthor: String){
        author = newAuthor
    }
    
    func setNotes(newNotes: String){
        notes = newNotes
    }
}

//reference: https://medium.com/programming-with-swift/easily-conform-to-codable-2e164a7c3dea
//used a tutorial from this site to get UIImages to conform to Codable
//this is so cover images inserted from photos (for custom items) can be stored in JSONs on the device
//that way they're saved when the app is closed and reopened
struct CodableImage: Codable{
    let imageData: Data?
    
    init(image: UIImage) {
        self.imageData = image.pngData()
    }
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}
