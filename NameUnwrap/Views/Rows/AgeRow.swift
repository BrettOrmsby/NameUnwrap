//
//  NationalityRow.swift
//  NameUnwrap
//
//  Created by Brett Ormsby on 2023-07-05.
//

import SwiftUI

struct AgeRow: View {
    @State var age: AgeResult
    var body: some View {
        EmojiRow(
            emoji: age.age == nil ? "🤔" : getAgeEmoji(age: age.age!),
            title: age.age == nil ? "Unknown Age": "\(String(age.age!)) Years Old"
        )
    }
}

func getAgeEmoji(age: Int) -> String {
    switch age {
    case 0...3:
        return "👶"
    case 4...15:
        return "🧒"
    case 16...49:
        return "🧑"
    case 50...64:
        return "🧑‍🦳"
    default:
        return "🧓"
    }
}

struct AgeRow_Previews: PreviewProvider {
    static var previews: some View {
        AgeRow(age: AgeResult(name: "Brett", age: 65, count: 0))
    }
}
