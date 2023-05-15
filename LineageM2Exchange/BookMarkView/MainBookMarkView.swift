//
//  MainBookMarkView.swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2023/01/20.
//

import SwiftUI

struct MainBookMarkView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: BookMarkEntity.entity() , sortDescriptors: [NSSortDescriptor(keyPath: \BookMarkEntity.timestamp, ascending: true)])
    
    var bookMarkData: FetchedResults<BookMarkEntity>
    
    @StateObject private var searchItemWithEnchant = SearchItemWithEnchantAPI.shared
    @StateObject private var searchServers = SearchServerAPI.shared
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { bookMarkData[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func findServerName(serverID: String? ) -> String {
        for data in searchServers.serverNames {
            if data.1 == Int(serverID!) {
                return data.0
            }
        }
        return ""
    }
    var body: some View {
        VStack {
            List {
                ForEach(bookMarkData) {data in
                    if !searchServers.serverNames.isEmpty {
                        let serverName: String = findServerName(serverID: data.serverID)
                        let condition: String = data.itemName! + data.serverID! + data.enchantLevel!
                        BookmarkCellView(serverName: serverName, condition: condition)
                            .onAppear {
                                searchItemWithEnchant.getMyIP(searchKeyword: data.itemName!, serverID: data.serverID!, enchantLevel: data.enchantLevel!)
                            }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .refreshable(action: {
                searchItemWithEnchant.posts = [ : ]
                for data in bookMarkData {
                    searchItemWithEnchant.getMyIP(searchKeyword: data.itemName!, serverID: data.serverID!, enchantLevel: data.enchantLevel!)
                }
            })
        }
    }
}
