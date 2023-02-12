//
//  FetchDataService.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/10/23.
//

import Foundation

class FetchDataService {
    static func fetchData(url: String, completion: @escaping ([[String:Any]]?, Error?) -> Void) {
        let url = URL(string: url)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
