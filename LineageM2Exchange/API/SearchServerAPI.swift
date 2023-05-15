//
//  SearchServerAPI.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/28.
//

import Foundation

class SearchServerAPI: ObservableObject {
    
    static let shared = SearchServerAPI()
    @Published var serverNames: [(String,Int,Int)] = []
    @Published var worldIDs: [Int] = []
    @Published var serverID: String?
    
    @Published var posts = [Servers]() {
        didSet {
            if !posts.isEmpty {
                let searchItem = SearchItemAPI.shared
                searchItem.getMyIP(searchKeyword: "", serverID: serverID ?? "1")
            }
        }
    }
    private let auth = Bundle.main.infoDictionary?["auth"] as! String
    func getMyIP() {
        let url = "https://dev-api.plaync.com/l2m/v1.0/market/servers"
        let header = ["Authorization" : "Bearer " + auth]
        
        var urlComponents = URLComponents(string: url)

        let queryItems = [URLQueryItem]()

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
                let apiResponse = try JSONDecoder().decode(Servers.self, from: data)
                DispatchQueue.main.async {
                    for worldIdx in apiResponse.indices {
                        let worldID = apiResponse[worldIdx].worldID ?? 0
                        self.worldIDs.append(worldID)
                        for serverIdx in apiResponse[worldIdx].servers.indices {
                            let serverName = apiResponse[worldIdx].servers[serverIdx].serverName
                            let serverID = apiResponse[worldIdx].servers[serverIdx].serverID
                            self.serverNames.append((serverName,serverID,worldID))
                        }
                    }
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

// MARK: - WelcomeElement
struct ServersElement: Codable {
    let worldName: String
    let worldID: Int?
    let servers: [Server]

    enum CodingKeys: String, CodingKey {
        case worldName = "world_name"
        case worldID = "world_id"
        case servers
    }
}

// MARK: - Server
struct Server: Codable {
    let serverID: Int
    let serverName: String

    enum CodingKeys: String, CodingKey {
        case serverID = "server_id"
        case serverName = "server_name"
    }
}

typealias Servers = [ServersElement]
