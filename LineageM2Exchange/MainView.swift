//
//  ContentView.swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2022/12/30.
//

import CoreData
import GoogleMobileAds
import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: ServersEntity.entity() , sortDescriptors: []) var saveData: FetchedResults<ServersEntity>
    @StateObject private var searchItemByCondition = SearchItemAPI.shared
    @StateObject private var searchServers = SearchServerAPI.shared
    @StateObject private var searchServerItemValueStaticsByCondition = SearchServerItemValueStatisticsAPI.shared
    @StateObject private var searchWorldItemValueStaticsByCondition = SearchWorldItemValueStatisticsAPI.shared
    @StateObject private var searchItemInfoByCondition = SearchItemInfoAPI.shared
    
    @EnvironmentObject var appData: AppData
    @State private var searchItemName = ""
    @State private var selectionOption = 0
    var body: some View {
        Color.BGC
            .overlay(
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
                    
//                    GADBannerViewController()
//                        .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
                    
                }
                    .font(Font.custom("PoorStory-Regular", size: 15, relativeTo: .title))
                    .foregroundColor(.gray)
            )
            .onAppear{
                if !saveData.isEmpty {
                    self.selectionOption = Int(saveData[0].serverIdx)
                }
            }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
