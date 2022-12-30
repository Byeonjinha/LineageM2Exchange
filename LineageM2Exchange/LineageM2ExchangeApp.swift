    //
//  LineageM2ExchangeApp.swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2022/12/30.
//

import AdSupport
import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

@main
struct LineageM2ExchangeApp: App {
    
    @StateObject private var searchServers = SearchServerAPI.shared
    @StateObject var appData =  AppData()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if NetworkReachability.isConnectedToNetwork() {
                MainView()
                    .environmentObject(appData)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear{
                        searchServers.getMyIP()
                    }
            } else {
                DisconnectedNetWorkView()
            }
        }
    }
}
