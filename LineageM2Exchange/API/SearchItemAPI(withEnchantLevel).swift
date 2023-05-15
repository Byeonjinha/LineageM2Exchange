//
//  SearchItemAPI(withEnchantLevel).swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2023/01/20.
//

import Foundation

class SearchItemWithEnchantAPI: ObservableObject {
    @Published var posts = [String:SearchItem]()
    static let shared = SearchItemWithEnchantAPI()
    private init() {
        
    }
    
    private let auth = Bundle.main.infoDictionary?["auth"] as! String
    func getMyIP(searchKeyword: String, serverID: String, enchantLevel: String) {
        let url = "https://dev-api.plaync.com/l2m/v1.0/market/items/search"
        let header = ["Authorization" : "Bearer " + auth]
            
        let params = ["search_keyword" : searchKeyword,
                      "from_enchant_level" : enchantLevel,
                      "to_enchant_level" : enchantLevel,
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
                    let key: String = searchKeyword + serverID + enchantLevel
                    self.posts[key] = apiResponse
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
