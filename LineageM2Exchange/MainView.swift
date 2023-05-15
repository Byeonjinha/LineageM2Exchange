//
//  ContentView.swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2022/12/30.
//

import AdSupport
import AppTrackingTransparency
import CoreData
import GoogleMobileAds
import SafariServices
import SwiftUI
import WebKit

struct MainView: View {
    // 코어데이터
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
    
    private var eventURL: String = "https://lineage2m.plaync.com/eventon"
    var body: some View {
        Color.BGC
            .overlay(
                VStack {
                    TabView {
                        MainItemSearchView (searchItemName: $searchItemName, selectionOption: $selectionOption)
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                                Text("아이템 검색")
                            }
                        MainBookMarkView()
                            .tabItem {
                                Image(systemName: "bookmark.fill")
                                Text("북마크")
                            }
                        let webView = MyWebView(urlToLoad: eventURL)
                        webView
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("이벤트")
                            }
                        
                    }
                    .font(Font.custom("PoorStory-Regular", size: 15, relativeTo: .title))
                    .foregroundColor(.gray)
                    GADBannerViewController()
                        .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
                }
            )
            .onAppear{
                if !saveData.isEmpty {
                    self.selectionOption = Int(saveData[0].serverIdx)
                    searchServers.serverID = String(selectionOption)
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
            }
        }
}
