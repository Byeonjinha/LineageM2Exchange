//
//  ItemView.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/29.
//

import SwiftUI

struct ItemView: View {
    let idx: Int?
    let image: String?
    let isWord: String?
    let itemName: String?
    let enchantLevel: Int?
    let nowMinUnitPrice: Double
    let itemID: String?
    let serverID: String?
    let grade: Color?
    
    @Binding var isOn: [Bool]
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: image!)) { phash in
                if let image = phash.image {
                    image.ImageModifier()
                } else if phash.error != nil {
                    Image(systemName: "exclamationmark.icloud.fill").IconModifier().foregroundColor(.red)
                } else {
                    Image(systemName: "photo.circle.fill").IconModifier().foregroundColor(.clear)
                }
            }
            .multilineTextAlignment(.leading)
            .frame(width: UIScreen.main.bounds.width * 0.1)
            let isWorld: String = isWord!
            Text(isWorld + " " + itemName! + "+" + String(enchantLevel!))
                .foregroundColor(grade)
                .frame(width: UIScreen.main.bounds.width * 0.66, alignment: .leading)
            if nowMinUnitPrice.truncatingRemainder(dividingBy: 1) == 0 {
                Text(String(format: "%.0f",  nowMinUnitPrice) + "D")
                    .frame(width: UIScreen.main.bounds.width * 0.18)
            } else {
                Text(String(format: "%.2f",  nowMinUnitPrice) + "D")
                    .frame(width: UIScreen.main.bounds.width * 0.2)
            }
        }
        .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(self.isOn[idx!] ? Color.searchTextBox : .clear))
        .font(Font.custom("PoorStory-Regular", size: 15, relativeTo: .title))
        .foregroundColor(Color.dia)
        .onTapGesture {
            self.isOn = [Bool](repeating: false, count:30)
            self.isOn[idx!] = true
            
            let searchServers = SearchServerAPI.shared
            var worldID: String?
            for serverIdx in searchServers.serverNames.indices {
                if Int(serverID!) == searchServers.serverNames[serverIdx].1 {
                    worldID = String(searchServers.serverNames[serverIdx].2)
                    break
                }
            }
            let searchServerItemValueStaticsByCondition = SearchServerItemValueStatisticsAPI.shared
            searchServerItemValueStaticsByCondition.posts = []
            searchServerItemValueStaticsByCondition.getMyIP(itemID: itemID!, worldID: worldID!, serverID: serverID!, enchantLevel: String(enchantLevel!))
            let searchWorldItemValueStaticsByCondition = SearchWorldItemValueStatisticsAPI.shared
            searchWorldItemValueStaticsByCondition.posts = []
            searchWorldItemValueStaticsByCondition.getMyIP(itemID: itemID!, worldID: worldID!, serverID: serverID!, enchantLevel: String(enchantLevel!))        
        }
    }
}
