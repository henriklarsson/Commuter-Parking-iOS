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
    var tokenTimeStamp : Int32 = 0
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getToken( completion: @escaping (Result<Token>) -> Void) {
        let parameters: Parameters = ["grant_type": "client_credentials"]      //This will be your parameter
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded", "Authorization" : "Basic U0E1WjNxUnNpYlByRWloNkQ2YTY4SkZqNzZ3YTpQVnRmZzlCa2NZSzd5aUhjMjgyQktseHFPblVh"
        ]
        
        
        Alamofire.request("https://api.vasttrafik.se/token", method: .post, parameters: parameters, encoding: URLEncoding(), headers:headers ).response { response in
            print(response.request)
            print(response.response)
            print(response.data)
            print(response.error)
            let decoder = JSONDecoder()
            do {
                self.token = try decoder.decode(Token.self, from: response.data!)
                let result = Result.success(self.token!)
                completion(result)
                print("Success! \(self.token).")
            } catch {

            }
          
        }
    }
//    @Query("format") format: String = "json",
//    @Query( "lat") lat: Double? = null,
//    @Query( "lon") lon: Double? = null,
//    @Query("dist") dist: Int? = null,
//    @Query("max") max: Int? = null): Deferred
    private func fetchParkings(lat: Double? = nil, long: Double? = nil, dist: Int? = nil, max: Int? = nil, completion :@escaping (Result<[ParkingLot]>)->Void){
        
        var parameters: Parameters = ["format": "json"]//This will be your parameter
        parameters["lat"] = lat
        parameters["long"] = long
        parameters["dist"] = dist
        parameters["max"] = max
        let headers =  ["Authorization": "Bearer " + token!.accessToken]
        
        Alamofire.request("https://api.vasttrafik.se/spp/v3/parkings", method: .get, parameters: parameters, headers: headers ).response { response in
//            print(response.request)
//            print(response.response)
//            print(response.data)
//            print(response.error)
            let string = String(decoding: response.data!, as: UTF8.self)
            print(string)
            let decoder = JSONDecoder()
            do {
                let parkingAreas = try decoder.decode([ParkingArea].self, from: response.data!)
                var parkings = [ParkingLot]()
                parkingAreas.forEach{ parkingArea in
                    parkingArea.parkingLots.forEach{ parkingLot in
                        parkings.append(parkingLot)
                    }
                }
                let result = Result.success(parkings)
                completion(result)
            } catch {
                
            }
        }
    }
    func getParkings(lat: Double? = nil, long: Double? = nil, dist: Int? = nil, max: Int? = nil, completion :@escaping (Result<[ParkingLot]>)->Void){
        
        if (isTokenValid()) {
           self.fetchParkings(lat: lat, long: long, dist: dist, max: max, completion: completion)
        } else {
            getToken(completion: { response in
                self.fetchParkings(lat: lat, long: long, dist: dist, max: max, completion: completion)
            })
        }
        
        
        
       
    }

    func isTokenValid() -> Bool {
        // rewrite with guard
        if (token != nil){
            return true
        } else {
            return false
        }
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
