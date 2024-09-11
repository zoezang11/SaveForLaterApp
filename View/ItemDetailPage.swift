//
//  ItemDetailPage.swift
//  FinalProject
//
//  Created by Zoe Zang on 4/19/24.
//

import SwiftUI
import Kingfisher

//when items from the grids on the Book/Movie/MusicListPages are clicked, navigate to this ItemDetailPage for each item
struct ItemDetailPage: View {
    @State var item: MyInfo
    let setHeight: CGFloat = 330
    let setWidth: CGFloat = 220 //needed for height/width of cover image
    let colorLightBlue = Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0)
    let colorTeal = Color(red: 80/255.0, green: 137/255.0, blue: 145/255.0)
    @EnvironmentObject var myLists: MyLists
    @Environment(\.dismiss) private var dismiss
    @State var showEdit = false
    
    var height : CGFloat { //images should be rectangles for movies/books, squares for music
        if(item.type == 2){
            return setWidth
        }
        else {
            return setHeight
        }
    }
    
    var labels : String {
        var s = ""
        for label in item.labels {
            s += " \(label) •"
        }
        return s
    }
    
    //edit image urls from APIs as needed
    func editString(s: String) -> String {
        var newS = s
        if(item.type == 0){
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
        ScrollView(.vertical){
            VStack(alignment: .center) { //show cover image -- same idea as in the ItemCell view
                if let c = item.cover { //want to load photo from api url
                    let s = editString(s: c)
                    if let url = URL(string: s) {
                        KFImage(url)
                            .resizable()
                            .frame(width: setWidth, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    else {
                        NoImage(height: height, setHeight: setHeight, setWidth: setWidth)
                    }
                }
                else if let customPhoto = item.photo { //want to load photo from photos
                    if let img = customPhoto.getImage() {
                        Image(uiImage: img)
                            .resizable()
                            .frame(width: setWidth, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    else {
                        NoImage(height: height, setHeight: setHeight, setWidth: setWidth)
                    }
                }
                else { //no image found
                    NoImage(height: height, setHeight: setHeight, setWidth: setWidth)
                }
                VStack(alignment: .leading, spacing: 12){ //show item information
                    Text("**Title:** \(item.title)") //display title
                        .font(.system(size: 22, design: .serif))
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorLightBlue)
                        )
                    if(item.type == 0){ //display author for books, year for movies, artist for music
                        Text("**Author:** \(item.author)")
                            .font(.system(size: 22, design: .serif))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorLightBlue)
                            )
                    }
                    else if(item.type == 1){
                        Text("**Year:** \(item.author)")
                            .font(.system(size: 24, design: .serif))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorLightBlue)
                            )
                    }
                    else {
                        Text("**Artist:** \(item.author)")
                            .font(.system(size: 24, design: .serif))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorLightBlue)
                            )
                    }
                    Text("**Notes:**") //display notes
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18, design: .serif))
                        .padding([.top], 4)
                    Text(LocalizedStringKey(item.notes)) //save as LocalizedStringKey so links are clickable
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18, design: .serif))
                        .padding([.bottom], 4)
                    Text("**Labelled as:** \(labels)")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18, design: .serif))
                    
                    if(showEdit){ //if the edit button is clicked, show this edit view
                        EditSaveElement(item: $item, setNotes: item.notes, setTitle: item.title, setAuthor: item.author, showEdit: $showEdit)
                    }
                    Spacer()
                }
                .padding([.top], 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Delete"){ //delete item from list when clicked and close page
                    myLists.removeItem(item: item)
                    dismiss()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorTeal)
                )
                .tint(Color.white)
                .bold()
                .opacity(showEdit ? 0 : 1)
                Button("Edit"){ //when clicked, edit view will show
                    showEdit = true
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorTeal)
                )
                .tint(Color.white)
                .bold()
                .opacity(showEdit ? 0 : 1)
            }
            .padding()
        }
        .scrollDismissesKeyboard(.immediately) //dismiss keyboard when the user scrolls
    }
}

struct LabelView: View {
    let colorLightBlue = Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0)
    var label: String
    
    var body: some View {
        HStack {
            Button(label){
                
            }
            .bold()
            Label("", systemImage: "x.square.fill")
                .tint(Color.white)
        }
        .padding([.leading, .bottom], 5)
        .padding([.top], 4)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(colorLightBlue)
        )
        .foregroundColor(Color.white)
    }
}

//view that allows user to edit the item information
struct EditSaveElement: View {
    let colorLightBlue = Color(red: 163/255.0, green: 199/255.0, blue: 204/255.0)
    let colorTeal = Color(red: 80/255.0, green: 137/255.0, blue: 145/255.0)
    @Binding var item: MyInfo
    @State var setNotes: String
    @State var setTitle: String
    @State var setAuthor: String
    @Binding var showEdit: Bool
    @State var reminderIcon: String = "plus"
    @State var date = Date()
    @EnvironmentObject var myLists: MyLists
    @Environment(\.dismiss) private var dismiss
    @State var selectedLabel = 0
    @State var newLabel = ""
    @State var labelIcon = "plus"
    @State var labelIconDelete = "x.square"
    @State var selectedLabelDelete = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("")
            Text("**Edit:**") //display title
                .font(.system(size: 22, design: .serif))
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorLightBlue)
                )
            TextField(item.title, text: $setTitle) //edit title
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorLightBlue)
                        .opacity(0.4)
                )
            TextField(item.author, text: $setAuthor) //edit author
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorLightBlue)
                        .opacity(0.4)
                )
            CustomTextView(text: $setNotes) //custom text view uses a UIKit element to make the format better for typing a lot of notes
                .frame(height: 100, alignment: .topLeading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorLightBlue)
                        .opacity(0.4)
                )
            Text("Set a reminder?") //set a reminder option (like on InsertPage)
                .bold()
                .padding(.top, 5)
                .fontDesign(.serif)
            HStack(spacing: 0) {
                DatePicker(
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
                Button("Add"){
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
            Text("Add labels:")
                .bold()
                .padding(.top, 5)
                .fontDesign(.serif)
            HStack{
                Text("From existing labels:")
                    .fontDesign(.serif)
                Picker("Label", selection: $selectedLabel){
                    ForEach(0..<myLists.filters.count, id: \.self){ index in
                        Text(myLists.filters[index]).tag(index)
                    }
                }
                .onTapGesture {
                    labelIcon = "plus"
                }
            }
            HStack {
                Text("Or create new: ")
                    .fontDesign(.serif)
                TextField("Label", text: $newLabel)
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
            HStack{
                Text("Delete labels:")
                    .fontDesign(.serif)
                    .bold()
                Picker("Label", selection: $selectedLabelDelete){
                    ForEach(0..<item.labels.count, id: \.self){ index in
                        Text(item.labels[index]).tag(index)
                    }
                }
                .onTapGesture {
                    labelIconDelete = "x.square"
                }
                Button(action: {
                    myLists.removeLabel(item: item, label: item.labels[selectedLabelDelete])
                    selectedLabelDelete = 0
                    labelIconDelete = "checkmark"
                }, label: {
                    Label("", systemImage: labelIconDelete)
                        .padding([.leading], 8)
                        .padding([.bottom], 3)
                        .tint(Color.white)
                        .bold()
                        .frame(width: 30, height: 30)
                        .background(colorTeal)
                        .clipShape(Circle())
                })
            }
            Button("Done"){ //saves edits
                let newItem = MyInfo(id: UUID(), title: setTitle, author: setAuthor, notes: setNotes, labels: item.labels, cover: item.cover, type: item.type, photo: item.photo)
                myLists.updateItem(newItem: newItem, oldItem: item, type: item.type)
                item = newItem
                showEdit = false
            }
            .frame(alignment: .center)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorTeal)
            )
            .tint(Color.white)
            .bold()
        }
    }
}

//CustomTextView wraps a UITextView so the format of typing a lot of notes is better
struct CustomTextView: UIViewRepresentable {
    @Binding var text: String
        
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.isEditable = true
        textView.delegate = context.coordinator
        textView.backgroundColor = UIColor(red: 163/255.0, green: 199/255.0, blue: 204/255.0, alpha: 0)
        textView.font = UIFont.systemFont(ofSize: 14)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>

        init(text: Binding<String>){
            self.text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}
