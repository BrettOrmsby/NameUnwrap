//
//  NationalityRow.swift
//  NameUnwrap
//
//  Created by Brett Ormsby on 2023-07-05.
//

import SwiftUI

struct GenderRow: View {
    @State var gender: GenderResult
    var body: some View {
        EmojiRow(
            emoji: getGenderEmoji(gender: gender.gender),
            title: capitalizeFirst(gender.gender?.rawValue ?? "Unknown Gender"),
            caption: gender.gender == .none ? nil : "\(Int(gender.probability*100))% Chance"
        )
    }
}

func capitalizeFirst(_ word: String) -> String {
    return word.prefix(1).uppercased() + word.dropFirst()
}

func getGenderEmoji(gender: Gender?) -> String {
    switch gender {
    case .male:
        return "👨‍💼"
    case .female:
        return "👩‍💼"
    default:
        return "🤔"
    }
}

struct GenderRow_Previews: PreviewProvider {
    static var previews: some View {
        GenderRow(gender: GenderResult(name: "bob", gender: .male, probability: 0.44, count: 4494))
    }
}
