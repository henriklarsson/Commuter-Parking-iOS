//
//  ParkingService.swift
//  PendelParkering
//
//  Created by Larsson, Henrik (94777) on 2019-05-22.
//  Copyright © 2019 Larsson, Henrik (94777). All rights reserved.
//

import Foundation
import Alamofire

class ParkingService {
    
    var token: Token? = nil
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    func getToken() {
        let parameters: Parameters = ["grant_type": "client_credentials"]      //This will be your parameter
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded", "Authorization" : "Basic U0E1WjNxUnNpYlByRWloNkQ2YTY4SkZqNzZ3YTpQVnRmZzlCa2NZSzd5aUhjMjgyQktseHFPblVh"
        ]
        let url = NSURL(string: "https://api.vasttrafik.se/token")!
        
        Alamofire.request("https://api.vasttrafik.se/token", method: .post, parameters: parameters, encoding: URLEncoding(), headers:headers ).response { response in
            print(response.request)
            print(response.response)
            print(response.data)
            let decoder = JSONDecoder()
            do {
                self.token = try decoder.decode(Token.self, from: response.data!)
                print("Success! \(token).")
            } catch {

            }
            print(response.error)
        }
    }
    
//    func getParkings(){
//        guard let url = URL(string: "https://api.vasttrafik.se/spp/v3/parking") else {
//
//            return
//        }
//
//        Alamofire.request(url,
//                          method: )
//
//
//    }
//
    func isTokenValid() -> Bool {
        return false
    }

}
extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
