//
//  SearchItemInfoAPI.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/28.
//

import Foundation

class SearchItemInfoAPI: ObservableObject {
    
    static let shared = SearchItemInfoAPI()
    private init() {  }
    @Published var posts = [ItemsInfo]()
    private let auth = Bundle.main.infoDictionary?["auth"] as! String
    func getMyIP() {
        let url = "https://dev-api.plaync.com/l2m/v1.0/market/items/100630003"
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
                let apiResponse = try JSONDecoder().decode(ItemsInfo.self, from: data)
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

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ItemsInfo: Codable {
    let itemID: Int
    let itemName: String
    let enchantLevel: Int
    let grade, gradeName: String
    let image: String
    let tradeCategoryName: String
    let options: [Option]
    let attribute: Attribute

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case itemName = "item_name"
        case enchantLevel = "enchant_level"
        case grade
        case gradeName = "grade_name"
        case image
        case tradeCategoryName = "trade_category_name"
        case options, attribute
    }
}

// MARK: - Attribute
struct Attribute: Codable {
    let safeEnchantLevel: Int
    let tradeable, enchantable, droppable, storable: Bool
    let attributeDescription: String
    let weight: Int
    let materialName: String
    let collectionCount: Int

    enum CodingKeys: String, CodingKey {
        case safeEnchantLevel = "safe_enchant_level"
        case tradeable, enchantable, droppable, storable
        case attributeDescription = "description"
        case weight
        case materialName = "material_name"
        case collectionCount = "collection_count"
    }
}

// MARK: - Option
struct Option: Codable {
    let optionName, display, extraDisplay: String

    enum CodingKeys: String, CodingKey {
        case optionName = "option_name"
        case display
        case extraDisplay = "extra_display"
    }
}
