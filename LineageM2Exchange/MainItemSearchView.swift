//
//  MainItemSearchItemView.swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2023/01/19.
//

import SwiftUI

struct MainItemSearchView: View {
    
    @StateObject private var searchServers = SearchServerAPI.shared
    @StateObject private var searchItemByCondition = SearchItemAPI.shared
    
    @Binding var searchItemName: String
    @Binding var selectionOption: Int
    
    var body: some View {
        VStack {
            Text("Powered by PLAYNC Developers")
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 8))
                .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
            SearchView(searchItemName: $searchItemName, selectionOption: $selectionOption)
                .frame(width: UIScreen.main.bounds.width * 0.98, height: UIScreen.main.bounds.height * 0.15)
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            if !searchItemByCondition.posts.isEmpty {
                Color.searchBox.overlay(
                    ScrollView (.vertical, showsIndicators: false) {
                        SearchItemView(serverID: String(searchServers.serverNames[selectionOption].1))
                        //HStack
                    }
                    //ScrollView
                )
                .frame(width: UIScreen.main.bounds.width * 0.98)
                .cornerRadius(10)
            }
            else {
                Color.searchBox.overlay(
                    ScrollView (.vertical, showsIndicators: false) {
                    }
                )
                .frame(width: UIScreen.main.bounds.width * 0.98)
                .cornerRadius(10)
            }
            
            
            VStack {
                Color.searchBox
                    .overlay(
                        HStack {
                            WorldItemStaticsView()
                            ServerItemStaticsView()
                        }
                    )
            }
            .frame(width: UIScreen.main.bounds.width * 0.98, height: UIScreen.main.bounds.height * 0.2)
            .cornerRadius(10)
        }
    }
}
