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
    private let auth = "eyJraWQiOiI1ZWM3ZTIzNy01MzA2LTQ5YjQtOThhYi0zZWNhNGMyYTg1MDciLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1aWQiOiI5MDE3RkM1QS01QUFCLTRCODAtODMzNi1FOUMzQkVDQkFGNTMifQ.PRKI6EO8tFkdz1JsQli2jh0x0cR7GG4QM6dLqLBqO-PTITc44fV5aAIx5bSTwg6HH7MSP9GOZL_v-y_jm62sPSi4AaCq-C3k0cV_z3B5kaeexa67Ux7EVe65S1cWFPMMn3wEx_EN5RWqD1yga7B6kdPdH6dwCSGsQrq3xaQ0TYErnhcL9NjX0RXD46h0rDWUMm_cw-x1JssEDG74UI--J3Gp_AwwObO8rLSGB3AsJ1pj5mhve8I42DokpqHn-Uy43EV4dlH_B-OVhzzP6Afg1kmVJbAU4jI53GAqzMLbedAzbIkKffTx0Fhqq4g_TRPrMskVpvfyh5VfNXPGwSseYQ"
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
//            print(response)
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
