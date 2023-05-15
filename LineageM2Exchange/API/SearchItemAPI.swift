//
//  searchItemAPI.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/28.
//

import Foundation

class SearchItemAPI: ObservableObject {
    var serverID: String?
    var worldID: String?
    @Published var posts = [SearchItem]() {
        didSet {
            if !posts.isEmpty && !posts[0].contents.isEmpty {
                let searchServers = SearchServerAPI.shared
                for serverIdx in searchServers.serverNames.indices {
                    if Int(serverID!) == searchServers.serverNames[serverIdx].1 {
                        self.worldID = String(searchServers.serverNames[serverIdx].2)
                        break
                    }
                }
                let itemID = String(posts[0].contents[0].itemID)
                let enchantLevel = String(posts[0].contents[0].enchantLevel)
                let searchServerItemValueStaticsByCondition = SearchServerItemValueStatisticsAPI.shared
                searchServerItemValueStaticsByCondition.posts = []
                searchServerItemValueStaticsByCondition.getMyIP(itemID: itemID, worldID: worldID ?? "1", serverID: serverID!, enchantLevel: enchantLevel)
                let searchWorldItemValueStaticsByCondition = SearchWorldItemValueStatisticsAPI.shared
                searchWorldItemValueStaticsByCondition.posts = []
                searchWorldItemValueStaticsByCondition.getMyIP(itemID: itemID, worldID: worldID ?? "1", serverID: serverID!, enchantLevel: enchantLevel)
            }
        }
    }
    static let shared = SearchItemAPI()
    private init() {
        
    }
    
    private let auth = Bundle.main.infoDictionary?["auth"] as! String
    func getMyIP(searchKeyword: String, serverID: String) {
        self.serverID = serverID
        let url = "https://dev-api.plaync.com/l2m/v1.0/market/items/search"
        let header = ["Authorization" : "Bearer " + auth]
            
        let params = ["search_keyword" : searchKeyword,
//                      "from_enchant_level" : "0",
//                      "to_enchant_level" : "10",
                      "server_id" : serverID ,
                      "sale" : "true",
                      "page" : "1",
                      "size" : "30"]

        var urlComponents = URLComponents(string: url)

        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"

        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                return
            }
            guard let data = data else{
                return
            }
            do{
                let apiResponse = try JSONDecoder().decode(SearchItem.self, from: data)
                DispatchQueue.main.async {
                    self.posts.append(apiResponse)
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("키문제 '\(key)' not found:", context.debugDescription)
                print("코딩패스문제:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("타입문제 '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        task.resume()
    }
}

// MARK: - searchItem
struct SearchItem: Codable {
    let contents: [Content]
    let pagination: Pagination
}

// MARK: - Content
struct Content: Codable {
    let itemID: Int
    let itemName: String
    let serverID: Int
    let serverName: String
    let world: Bool
    let enchantLevel: Int
    let grade: String
    let image: String
    let avgUnitPrice : Double
    let nowMinUnitPrice : Double

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case itemName = "item_name"
        case serverID = "server_id"
        case serverName = "server_name"
        case world
        case enchantLevel = "enchant_level"
        case grade, image
        case nowMinUnitPrice = "now_min_unit_price"
        case avgUnitPrice = "avg_unit_price"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let page, size, lastPage, total: Int

    enum CodingKeys: String, CodingKey {
        case page, size
        case lastPage = "last_page"
        case total
    }
}
