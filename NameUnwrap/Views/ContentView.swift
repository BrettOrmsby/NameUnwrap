//
//  ContentView.swift
//  NameUnwrap
//
//  Created by Brett Ormsby on 2023-07-03.
//

import SwiftUI

struct ContentView: View {
    let spacing: CGFloat = 30
    @State private var name: String = ""
    @State private var isError: Bool = false {
        didSet {
            nameData = nil
        }
    }
    @State private var nameData: NameData?
    @State var viewID = 0 // Used to force update the age row view when the age changes
    
    struct NameData {
        var nationality: NationalityResult
        var age: AgeResult
        var gender: GenderResult
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Name Unwrap")
                        .font(.largeTitle)
                    HStack {
                        Text("Name:")
                            .font(.body)
                        TextField("Jhon", text: $name)
                            .font(.body)
                    }
                    Button(action: {
                        isError = false
                        loadNameData()
                    }) {
                        Text("Load Information")
                            .font(.body)
                    }
                    Spacer(minLength: spacing)
                    
                    if isError {
                        Text("There was an error loading the name information.")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    if let nameData = nameData {
                        Group() {
                            Text("Hello \(nameData.age.name)")
                                .font(.title)
                            
                            Spacer(minLength: spacing/2)
                            Text("Age")
                                .font(.title2)
                            Spacer(minLength: spacing/4)
                            AgeRow(age: nameData.age).id(viewID)
                            
                            Spacer(minLength: spacing/2)
                            Text("Gender")
                                .font(.title2)
                            Spacer(minLength: spacing/4)
                            GenderRow(gender: nameData.gender).id(viewID)
                        }
                        
                        Spacer(minLength: spacing/2)
                        Text("Nationality")
                            .font(.title2)
                        Spacer(minLength: spacing/4)
                            
                        if(nameData.nationality.country.isEmpty) {
                            EmojiRow(emoji: "🤔", title: "Unknown Nationality")
                        } else {
                            ForEach(nameData.nationality.country) { nationality in
                                NationalityRow(nationality: nationality)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        
    }
    
    func loadNameData() {
        if(name.isEmpty) {
            isError = true
            return
        }
        let nationality = getNationality(name: name)
        let gender = getGender(name: name)
        let age = getAge(name: name)
        
        if case .success(let nationality) = nationality, case .success(let gender) = gender, case .success(let age) = age   {
            nameData = NameData(nationality: nationality, age: age, gender: gender)
            viewID += 1
        } else {
            isError = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .light)
            
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}
