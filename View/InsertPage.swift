//
//  InsertPage.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/9/24.
//

import SwiftUI
import PhotosUI
import EventKit

//on the Insert page the user can add new media by searching using the APIs or creating a custom entry
//users can also customize media entries by adding notes and scheduling notifications
struct InsertPage: View {
    //colors for UI
    let colorWhite = Color(red: 252/255.0, green: 251/255.0, blue: 238/255.0)
    let colorMintGreen = Color(red: 203/255.0, green: 223/255.0, blue: 189/255.0)
    let colorYellowGreen = Color(red: 212/255.0, green: 224/255.0, blue: 155/255.0)
    let colorTeal = Color(red: 80/255.0, green: 137/255.0, blue: 145/255.0)
    let colorLightBlue = Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0)
    
    @State var searchTerms = ""
    @StateObject var bookViewModel: BookViewModel = BookViewModel()
    @StateObject var musicViewModel: MusicViewModel = MusicViewModel()
    @StateObject var movieViewModel: MovieViewModel = MovieViewModel()
    @EnvironmentObject var myLists: MyLists
    @State var typeSelected = 0
    @State var notes = ""
    @State var custom = false
    @State var showCustom = false
    @State var customTitle = ""
    @State var customAuthor = ""
    @State var customPhotoItem: PhotosPickerItem?
    @State var customImage: CodableImage?
    @State var customImageIcon: String = "plus"
    @State var reminderIcon: String = "plus"
    @State var date = Date()
    @State var selectedLabel = 0
    @State var newLabel = ""
    @State var labelIcon = "plus"
    let items: [GridItem] = [
        GridItem(.flexible(minimum: 120))
    ]
    
    var body: some View {
        VStack {
            Text("Insert")
                .font(.system(size: 38, weight: .bold, design: .serif))
                .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                .padding(.top, 16)
            RoundedRectangle(cornerRadius: 5)
                .fill(colorLightBlue)
                .frame(height: 4)
            //type of media to insert
            Picker("Type", selection: $typeSelected){
                Text("Book").tag(0)
                Text("Movie").tag(1)
                Text("Show").tag(3)
                Text("Music").tag(2)
            }
            .pickerStyle(.segmented)
            .padding([.top, .bottom], 8)
            HStack { //search bar and button
                TextField("What are you looking for?", text: $searchTerms)
                    .frame(height: 20)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorLightBlue)
                            .opacity(0.4)
                    )
                Button("Search"){
                    showCustom = false
                    myLists.newItem = nil
                    if(typeSelected == 0){ //call different API based on type selected
                        Task {
                            await bookViewModel.search(terms: searchTerms)
                            searchTerms = ""
                        }
                    }
                    else if(typeSelected == 2){
                        Task {
                            await musicViewModel.search(terms: searchTerms)
                            searchTerms = ""
                        }
                    }
                    else if(typeSelected == 1){
                        Task {
                            await movieViewModel.search(terms: searchTerms)
                            searchTerms = ""
                        }
                    }
                    else if(typeSelected == 3){
                        Task {
                            await movieViewModel.searchTV(terms: searchTerms)
                            searchTerms = ""
                        }
                    }
                }
                .padding(12)
                .tint(Color.white)
                .bold()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorTeal)
                )
            }
            
            //scroll view to hold results from search (different call for each different type
            ScrollView(.vertical){
                if typeSelected==0 && !bookViewModel.searchResults.items.isEmpty {
                    LazyVGrid(columns: items, alignment: .leading, spacing: 10){
                        ForEach(bookViewModel.searchResults.items) { book in
                            BookSearchView(book: book)
                                .padding(4)
                        }
                    }
                }
                else if typeSelected==2 && !musicViewModel.searchResults.albums.items.isEmpty {
                    LazyVGrid(columns: items, alignment: .leading, spacing: 10){
                        ForEach(musicViewModel.searchResults.albums.items) { album in
                            MusicSearchView(album: album)
                                .padding(4)
                        }
                    }
                }
                else if typeSelected==1 && !movieViewModel.searchResults.results.isEmpty {
                    LazyVGrid(columns: items, alignment: .leading, spacing: 10){
                        ForEach(movieViewModel.searchResults.results) { movie in
                            MovieSearchView(movie: movie)
                                .padding(4)
                        }
                    }
                }
                else if typeSelected==3 && !movieViewModel.searchResultsTV.results.isEmpty {
                    LazyVGrid(columns: items, alignment: .leading, spacing: 10){
                        ForEach(movieViewModel.searchResultsTV.results) { tv in
                            TVSearchView(tv: tv)
                                .padding(4)
                        }
                    }
                }
                else {
                    Text("No results found")
                }
            }
            .frame(maxHeight: (myLists.newItem != nil || showCustom) ? 0 : .infinity)
            .scrollDismissesKeyboard(.immediately)
            
            //create a custom entry instead of searching
            if(myLists.newItem == nil){
                Button("Custom") {
                    showCustom = true
                }
                .padding(12)
                .tint(Color.white)
                .bold()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(!showCustom ? colorTeal : Color.white)
                )
                .disabled(showCustom)
            }
            
            //for creating custom items: show if the button is clicked
            if(showCustom){
                VStack { //enter title
                    TextField("Title", text: $customTitle)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorLightBlue)
                                .opacity(0.4)
                        )
                    if typeSelected == 1 || typeSelected == 3 { //enter author/year/artist based on media type
                        TextField("Year", text: $customAuthor)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorLightBlue)
                                    .opacity(0.4)
                            )
                    } 
                    else if typeSelected == 2 { //music
                        TextField("Artist", text: $customAuthor)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorLightBlue)
                                    .opacity(0.4)
                            )
                    }
                    else { //book
                        TextField("Author", text: $customAuthor)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorLightBlue)
                                    .opacity(0.4)
                            )
                    }
                    HStack { //add a cover photo to the custom entry
                        Label("", systemImage: customImageIcon)
                            .padding([.leading], 8)
                            .padding([.bottom], 3)
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.white)
                        PhotosPicker("Add Cover Photo", selection: $customPhotoItem, matching: .images)
                            .onChange(of: customPhotoItem) { oldValue, newValue in
                                guard let newValue else {
                                    return
                                }
                                Task {
                                    do {
                                        guard let data = try await newValue.loadTransferable(type: Data.self) else {
                                            print("cannot convert photo item to data")
                                            return
                                        }
                                        guard let uiImage = UIImage(data: data) else {
                                            print("cannot load ui image")
                                            return
                                        }
                                        customImage = CodableImage(image: uiImage)
                                        customImageIcon = "checkmark"
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                    }
                    .padding(12)
                    .tint(Color.white)
                    .bold()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorTeal)
                    )
                    
                    Button("Done"){ //saves custom entry when the user is done editing
                        myLists.setNewItem(title: customTitle, author: customAuthor, type: typeSelected, cover: nil, photo: customImage)
                        showCustom = false
                        customTitle = ""
                        customAuthor = ""
                        customImageIcon = "plus"
                        customPhotoItem = nil
                        customImage = nil
                    }
                    .disabled(customTitle == "" || customAuthor == "")
                    .padding(12)
                    .tint(Color.white)
                    .bold()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorTeal)
                    )
                }
            }
            
            //when an entry is ready (searched or custom) add information and add it to the relevant list
            if let item = myLists.newItem {
                ScrollView {
                    VStack {
                        HStack { //display media name and author
                            Label("", systemImage: "checkmark")
                                .padding([.leading], 8)
                                .padding([.bottom], 3)
                                .frame(width: 30, height: 30)
                                .background(colorLightBlue)
                                .clipShape(Circle())
                            VStack(alignment: .leading){
                                Text(item.title)
                                Text(item.author)
                                    .font(.caption)
                            }
                            .padding(.leading, 4)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorLightBlue)
                                .opacity(0.4)
                        )
                        VStack(alignment: .center, spacing: 8){
                            Text("Notes") //add notes
                                .bold()
                                .padding(.top, 5)
                                .fontDesign(.serif)
                            CustomTextView(text: $notes)
                                .frame(height: 100, alignment: .topLeading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(colorLightBlue)
                                        .opacity(0.4)
                                )
                            Text("Set a reminder?") //add a reminder
                                .bold()
                                .padding(.top, 5)
                                .fontDesign(.serif)
                            HStack(spacing: 0) {
                                DatePicker( //pick a date and time for the reminder
                                    "",
                                    selection: $date,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .padding([.trailing], 8)
                                Label("", systemImage: reminderIcon)
                                    .padding([.leading], 12)
                                    .padding([.bottom], 3)
                                    .frame(width: 35, height: 45)
                                    .foregroundStyle(Color.white)
                                    .background(
                                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 12, bottomLeading: 12, bottomTrailing: 0,topTrailing: 0))
                                            .fill(colorTeal)
                                    )
                                    .bold()
                                Button("Add"){ //when this button is clicked, add the reminder
                                    addReminder(item: item, date: date)
                                    reminderIcon = "checkmark"
                                }
                                .padding([.top, .bottom, .trailing], 12)
                                .background(
                                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 0, bottomTrailing: 12, topTrailing: 12))
                                        .fill(colorTeal)
                                )
                                .tint(Color.white)
                                .bold()
                                Spacer()
                            }
                            .padding([.trailing], 20)
                            Text("Add labels")
                                .bold()
                                .padding(.top, 5)
                                .fontDesign(.serif)
                            HStack{
                                Picker("Label", selection: $selectedLabel){
                                    ForEach(0..<myLists.filters.count, id: \.self){ index in
                                        Text(myLists.filters[index]).tag(index)
                                    }
                                }
                                .onTapGesture {
                                    labelIcon = "plus"
                                }
                                TextField("New", text: $newLabel)
                                    .padding(12)
                                    .frame(maxWidth: 180)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(colorLightBlue)
                                            .opacity(0.4)
                                    )
                                    .onTapGesture {
                                        labelIcon = "plus"
                                    }
                                    .onChange(of: newLabel, {
                                        if(newLabel != ""){
                                            labelIcon = "plus"
                                        }
                                    })
                                Button(action: {
                                    if(newLabel != ""){
                                        item.labels.append(newLabel)
                                        myLists.filters.append(newLabel)
                                    }
                                    if(selectedLabel != 0){
                                        item.labels.append(myLists.filters[selectedLabel])
                                    }
                                    newLabel = ""
                                    selectedLabel = 0
                                    labelIcon = "checkmark"
                                }, label: {
                                    Label("", systemImage: labelIcon)
                                        .padding([.leading], 8)
                                        .padding([.bottom], 3)
                                        .tint(Color.white)
                                        .bold()
                                        .frame(width: 30, height: 30)
                                        .background(colorTeal)
                                        .clipShape(Circle())
                                })
                            }
                        }
                        Button("Done") { //when done adding information, clicking this button saves the new entry
                            myLists.newItem!.notes = notes
                            if(typeSelected == 0){ //add to MyLists based on media type
                                myLists.myBooks.append(myLists.newItem!)
                            }
                            else if(typeSelected == 2){
                                myLists.myMusic.append(myLists.newItem!)
                            }
                            else if(typeSelected == 1 || typeSelected == 3){
                                myLists.myMovies.append(myLists.newItem!)
                            }
                            myLists.newItem = nil
                            searchTerms = ""
                            notes = ""
                            selectedLabel = 0
                            newLabel = ""
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorTeal)
                        )
                        .tint(Color.white)
                        .bold()
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
            Spacer()
        }
        .padding()
        .environmentObject(myLists)
    }
    
}

//reference: https://medium.com/@rohit.jankar/using-swift-a-guide-to-adding-reminders-in-the-ios-reminder-app-with-the-eventkit-api-020b2e6b38bb
//function to add reminders given an item and date/time
func addReminder(item: MyInfo, date: Date){
    let events = EKEventStore()
    
    events.requestFullAccessToReminders(){ granted, error in
        if granted && error == nil {
            let reminder = EKReminder(eventStore: events)
            reminder.title = item.title
            reminder.dueDateComponents = Calendar.current.dateComponents(
                [
                    .year,
                    .month,
                    .day,
                    .hour,
                    .minute
                ],
                from: date
            )
            let defaultReminderCalendar = events.defaultCalendarForNewReminders()
            if let defaultCalendar = defaultReminderCalendar {
                reminder.calendar = defaultCalendar
                do {
                    try events.save(reminder, commit: true)
                    print( "Reminder added successfully.")
                } catch {
                    print("Error adding reminder: \(error.localizedDescription)")
                }
            } else {
                print("No default reminder calendar found.")
            }
        } else {
            print("access to reminders not granted")
        }
    }
}

#Preview {
    InsertPage()
        .environmentObject(MyLists())
}
