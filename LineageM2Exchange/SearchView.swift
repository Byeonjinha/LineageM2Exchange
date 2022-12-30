//
//  SearchView.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/29.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: ServersEntity.entity() , sortDescriptors: []) var saveData: FetchedResults<ServersEntity>
    @StateObject private var searchItemByCondition = SearchItemAPI.shared
    @StateObject private var searchServers = SearchServerAPI.shared
    @Binding var searchItemName: String
    @Binding var selectionOption: Int
    
    public func addItem() {
        let newData = ServersEntity(context: viewContext)
        newData.serverIdx = Int16(selectionOption)
        saveItems()
        do {
            try viewContext.save()
            saveData[0].serverIdx = Int16(0)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    public func saveItems() {
        do {
            try viewContext.save()
            saveData[0].serverIdx = Int16(selectionOption)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    var body: some View {
        Color.searchBox
            .overlay(
                HStack {
                    if !searchServers.serverNames.isEmpty {
                        Picker("", selection: $selectionOption) {
                            ForEach(0 ..< searchServers.serverNames.count , id: \.self) {
                                Text(searchServers.serverNames[$0].0)
                                    .font(Font.custom("PoorStory-Regular", size: 15, relativeTo: .title))
                                    .foregroundColor(.gray)
                                
                            }
                        }
                        .onChange(of: selectionOption, perform:{  (value) in
                            if saveData.isEmpty {
                                addItem()
                            } else {
                                saveItems()
                            }
                        })
                        .pickerStyle(.wheel)
                        .labelsHidden()
                        .frame(width: UIScreen.main.bounds.width * 0.28, height: UIScreen.main.bounds.height * 0.14)
                        .clipped()
                        .compositingGroup()
                        .padding()
                    } else {
                        Picker("", selection: $selectionOption) {
                        }
                        .pickerStyle(.wheel)
                        .labelsHidden()
                        .frame(width: UIScreen.main.bounds.width * 0.28, height: UIScreen.main.bounds.height * 0.14)
                        .clipped()
                        .compositingGroup()
                        .padding()
                    }
                    Color.searchTextBox
                        .frame(width: UIScreen.main.bounds.width * 0.54, height:  UIScreen.main.bounds.height * 0.06)
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                TextField("" , text : $searchItemName)
                                    .placeholder(when: searchItemName.isEmpty) {
                                        Text("아이템 이름")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .font(Font.custom("PoorStory-Regular", size: 15, relativeTo: .title))
                                    .foregroundColor(.gray)
                                Button(action:{
                                    print(selectionOption)
                                    searchItemByCondition.posts = []
                                    searchItemByCondition.getMyIP(searchKeyword: searchItemName, serverID: String(searchServers.serverNames[selectionOption].1))
                                })
                                {  Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .frame(width: 15, height: 15)
                                        .padding()
                                }
                                
                            }
                        )
                }
            )
    }
}

