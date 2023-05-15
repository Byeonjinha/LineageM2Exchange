//
//  BookmarkCellView.swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2023/01/20.
//

import SwiftUI

struct BookmarkCellView: View {
    
    @StateObject private var searchItemWithEnchant = SearchItemWithEnchantAPI.shared
    
    var serverName: String
    var condition: String
    var body: some View {
        HStack {
            Text("[\(serverName)]")
            if let itemData = searchItemWithEnchant.posts[condition] {
                if !itemData.contents.isEmpty {
                    let grade = findItemColor(grade: itemData.contents[0].grade)
                    let image = itemData.contents[0].image
                    
                    AsyncImage(url: URL(string: image)) { phash in
                        if let image = phash.image {
                            image.ImageModifier()
                        } else if phash.error != nil {
                            Image(systemName: "exclamationmark.icloud.fill").IconModifier().foregroundColor(.red)
                        } else {
                            Image(systemName: "photo.circle.fill").IconModifier().foregroundColor(.clear)
                        }
                    }
                    .multilineTextAlignment(.leading)
                    
                    .frame(width: UIScreen.main.bounds.width * 0.06)
                    Text(itemData.contents[0].itemName + "+" + String(itemData.contents[0].enchantLevel))
                        .foregroundColor(grade)
                    
                    Spacer()
                    let nowMinUnitPrice = itemData.contents[0].nowMinUnitPrice
                    if nowMinUnitPrice.truncatingRemainder(dividingBy: 1) == 0 {
                        Text(String(format: "%.0f",  nowMinUnitPrice) + "D")
                            .foregroundColor(Color.dia)
                    } else {
                        Text(String(format: "%.2f",  nowMinUnitPrice) + "D")
                            .foregroundColor(Color.dia)
                    }
                }
            }
           
//            Text(data.itemName ?? "")
         
        }
    }
}
