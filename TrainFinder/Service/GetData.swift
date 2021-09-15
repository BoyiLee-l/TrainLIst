//
//  NetworkData.swift
//  BusFinder
//
//  Created by user on 2021/3/8.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Resource<T: Decodable> {
    let url: URL
}

class GetData {
    
    func getBusRoute<T>(resource:Resource<T>, completion: @escaping (T?) -> Void) {
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")

        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result)
            } catch {
                print(error)
                completion(nil)
            }
        }.resume()
    }
    
}
