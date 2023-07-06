//
//  NationalityRow.swift
//  NameUnwrap
//
//  Created by Brett Ormsby on 2023-07-05.
//

import SwiftUI

struct EmojiRow: View {
    @State var emoji: String
    @State var title: String
    @State var caption: String?
    
    var body: some View {
        HStack(alignment: .center) {
            Text(emoji)
                .font(.system(size: 60.0))
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                if(caption != nil) {
                    Text(caption!)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(5)
        .background(Color("Card"))
        .cornerRadius(5)
        .shadow(radius: 10)
    }
}

struct EmojiRow_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRow(emoji: "👵", title: "99", caption: "Yup, thats old")
    }
}
