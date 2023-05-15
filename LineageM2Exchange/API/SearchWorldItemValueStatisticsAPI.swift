//
//  SearchWorldItemValueStatisticsAPI.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/29.
//

import Foundation

class SearchWorldItemValueStatisticsAPI: ObservableObject {
    
    static let shared = SearchWorldItemValueStatisticsAPI()
    private init() {  }
    @Published var posts = [SearchItemValueStatistics]()
    private let auth = Bundle.main.infoDictionary?["auth"] as! String
    func getMyIP(itemID: String, worldID: String, serverID: String, enchantLevel: String) {
        let url = "https://dev-api.plaync.com/l2m/v1.0/market/items/\(itemID)/price"
        let header = ["Authorization" : "Bearer " + auth]
        let params = ["enchant_level" : enchantLevel,
                      "server_id" : worldID]

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
                let apiResponse = try JSONDecoder().decode(SearchItemValueStatistics.self, from: data)
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
