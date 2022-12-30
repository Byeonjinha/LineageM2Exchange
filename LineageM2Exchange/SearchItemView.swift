//
//  SearchItemView.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/29.
//

import SwiftUI

struct SearchItemView: View {
    @StateObject private var searchItemByCondition = SearchItemAPI.shared
    @State var isOn = [Bool](repeating: false, count:30)
    let serverID: String?
    var body: some View {
        if !searchItemByCondition.posts.isEmpty {
            VStack {
                ForEach(0..<searchItemByCondition.posts[0].contents.count , id: \.self) { idx in
                    let image = searchItemByCondition.posts[0].contents[idx].image
                    let isWord = searchItemByCondition.posts[0].contents[idx].world ? "[월드]" : "[서버]"
                    let itemName = searchItemByCondition.posts[0].contents[idx].itemName
                    let enchantLevel = searchItemByCondition.posts[0].contents[idx].enchantLevel
                    let nowMinUnitPrice = searchItemByCondition.posts[0].contents[idx].nowMinUnitPrice
                    let itemID = String(searchItemByCondition.posts[0].contents[idx].itemID)
                    let grade = findItemColor(grade: searchItemByCondition.posts[0].contents[idx].grade)
                    ItemView(idx: idx, image: image, isWord: isWord, itemName: itemName, enchantLevel: enchantLevel, nowMinUnitPrice: nowMinUnitPrice, itemID: itemID, serverID: serverID, grade: grade, isOn: $isOn)
                }
            }
            .onAppear {
                self.isOn = [Bool](repeating: false, count: searchItemByCondition.posts[0].contents.count)
                if !isOn.isEmpty {
                    self.isOn[0] = true
                }
            }
        }
    }
}

extension Image {
    func ImageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
    
    func IconModifier() -> some View {
        self
            .ImageModifier()
            .frame(maxWidth: 200)
            .opacity(0.6)
    }
}

func findItemColor(grade: String) -> Color {
    switch grade {
    case "uncommon":  return Color.uncommon
    case "rare":  return Color.rare
    case "mythic":  return Color.mythic
    case "legendary":  return Color.legendary
    case "epic":  return Color.epic
    case "common":  return Color.common
    default:
        return Color.common
    }
}
