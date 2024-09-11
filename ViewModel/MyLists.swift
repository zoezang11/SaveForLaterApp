//
//  MyLists.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import Foundation
import SwiftUI

//MyLists stores the list of books: myBooks, list of movies: myMovies, and list of music: myMusic
class MyLists: ObservableObject {
    @Published var myBooks: [MyInfo] {
        didSet {
            saveBooks()
        }
    }
    @Published var myMusic: [MyInfo] {
        didSet {
            saveMusic()
        }
    }
    @Published var myMovies: [MyInfo] {
        didSet {
            saveMovies()
        }
    }
    @Published var newItem: MyInfo? = nil
    @Published var filters: [String] {
        didSet {
            saveFilters()
        }
    }
    //save JSON data at a different file path for each type of media list
    private let booksFilePath: URL
    private let musicFilePath: URL
    private let moviesFilePath: URL
    private let filtersFilePath: URL
    
    init(){ //try to load data in from device
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        booksFilePath = URL(string: "\(url)/books.json")!
        musicFilePath = URL(string: "\(url)/music.json")!
        moviesFilePath = URL(string: "\(url)/movies.json")!
        filtersFilePath = URL(string: "\(url)/filters.json")!
        myBooks = []
        myMusic = []
        myMovies = []
        filters = ["None"]
        let booksLoaded = loadBooks()
        let musicLoaded = loadMusic()
        let moviesLoaded = loadMovies()
        let filtersLoaded = loadFilters()
        if let booksLoaded {
            myBooks = booksLoaded
        }
        if let musicLoaded {
            myMusic = musicLoaded
        }
        if let moviesLoaded {
            myMovies = moviesLoaded
        }
        if let filtersLoaded {
            filters = filtersLoaded
        }
    }
    
    //try to decode books from the JSON when MyLists is initialized
    private func loadBooks() -> [MyInfo]?{
        do {
            let data = try Data(contentsOf: booksFilePath)
            let decoder = JSONDecoder()
            let books = try decoder.decode(Array<MyInfo>.self, from: data)
            return books
        } catch {
            print(error)
            return nil
        }
    }
    
    //save books to device as a JSON
    private func saveBooks(){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(myBooks)
            try data.write(to: booksFilePath)
        } catch {
            print(error)
        }
    }
    
    //loadMusic & saveMusic and loadMovies & saveMovies are the same idea as loadBooks & saveBooks above
    private func loadMusic() -> [MyInfo]?{
        do {
            let data = try Data(contentsOf: musicFilePath)
            let decoder = JSONDecoder()
            let music = try decoder.decode(Array<MyInfo>.self, from: data)
            return music
        } catch {
            print(error)
            return nil
        }
    }
    
    private func saveMusic(){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(myMusic)
            try data.write(to: musicFilePath)
        } catch {
            print(error)
        }
    }
    
    private func loadMovies() -> [MyInfo]?{
        do {
            let data = try Data(contentsOf: moviesFilePath)
            let decoder = JSONDecoder()
            let movies = try decoder.decode(Array<MyInfo>.self, from: data)
            return movies
        } catch {
            print(error)
            return nil
        }
    }
    
    private func saveMovies(){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(myMovies)
            try data.write(to: moviesFilePath)
        } catch {
            print(error)
        }
    }
    
    //load filters list from file
    private func loadFilters() -> [String]?{
        do {
            let data = try Data(contentsOf: filtersFilePath)
            let decoder = JSONDecoder()
            let labels = try decoder.decode(Array<String>.self, from: data)
            return labels
        } catch {
            print(error)
            return nil
        }
    }
    
    //save filters list to file
    private func saveFilters(){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(filters)
            try data.write(to: filtersFilePath)
        } catch {
            print(error)
        }
    }
    
    //update an item given the original item and the new item you want to replace it with, plus an integer representing what media type it is
    func updateItem(newItem: MyInfo, oldItem: MyInfo, type: Int){
        if(type == 0){ //book
            for index in 0..<myBooks.count { //if book, remove and insert to myBooks
                if myBooks[index] == oldItem {
                    myBooks.remove(at: index)
                    myBooks.insert(newItem, at: index)
                }
            }
        }
        else if(type == 1){//movie
            for index in 0..<myMovies.count { //if movie, remove and insert to myMovies
                if myMovies[index] == oldItem {
                    myMovies.remove(at: index)
                    myMovies.insert(newItem, at: index)
                }
            }
        }
        else if(type == 2){//music
            for index in 0..<myMusic.count { //if music, remove and insert to myMusic
                if myMusic[index] == oldItem {
                    myMusic.remove(at: index)
                    myMusic.insert(newItem, at: index)
                }
            }
        }
    }

    //create a new item
    func setNewItem(title: String, author: String, type: Int, cover: String?, photo: CodableImage?){
        var label = "Book"
        if type == 1 {
            label = "Movie"
        }
        else if type == 2 {
            label = "Music"
        }
        newItem = MyInfo(id: UUID(), title: title, author: author, notes: "", labels: [label], cover: cover, type: type, photo: photo)
    }
    
    //remove an item
    func removeItem(item: MyInfo){
        if item.type == 0 {
            var i = 0
            for element in myBooks {
                if element == item {
                    myBooks.remove(at: i)
                    return
                }
                i = i+1
            }
        }
        else if item.type == 1 {
            var i = 0
            for element in myMovies {
                if element == item {
                    myMovies.remove(at: i)
                    return
                }
                i = i+1
            }
        }
        else if item.type == 2 {
            var i = 0
            for element in myMusic {
                if element == item {
                    myMusic.remove(at: i)
                    return
                }
                i = i+1
            }
        }
    }
    
    //sort given the type of media and up to two search terms from the FilterPage
    func sort(type: Int, one: String, two: String) -> [MyInfo]? {
        var returnItems: [MyInfo] = []
        var typeList: [MyInfo] = myBooks
        if(type == 1){
            typeList = myMovies
        }
        else if(type==2){
            typeList = myMusic
        }
        
        var searchTerm = ""
        if(one == "None" && two == "None"){
            return typeList
        }
        else if(one == "None"){
            searchTerm = two
        }
        else if(two == "None"){
            searchTerm = one
        }
        
        if(searchTerm != ""){
            for item in typeList {
                if(item.labels.contains(searchTerm)){
                    returnItems.append(item)
                }
            }
        } else {
            for item in typeList {
                if(item.labels.contains(one) && item.labels.contains(two)){
                    returnItems.append(item)
                }
            }
        }
        if(returnItems.isEmpty){
            return nil
        }
        return returnItems
    }
    
    //remove label from one item
    func removeLabel(item: MyInfo, label: String){
        item.labels.removeAll(where: {$0 == label})
    }
    
    //remove label from overall filters list and from any item that has it
    func removeLabelFromAll(label: String){
        filters.removeAll(where: {$0 == label})
        
        removeLabelFromList(list: myBooks, label: label)
        removeLabelFromList(list: myMovies, label: label)
        removeLabelFromList(list: myMusic, label: label)
    }
    
    //helper for remove label from all, removes label from all items in a given list
    func removeLabelFromList(list: [MyInfo], label: String){
        for item in list {
            item.labels.removeAll(where: {$0 == label})
        }
    }
    
    
}
