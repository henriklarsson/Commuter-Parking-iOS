//
//  ParkingService.swift
//  PendelParkering
//
//  Created by Larsson, Henrik (94777) on 2019-05-22.
//  Copyright © 2019 Larsson, Henrik (94777). All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

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
    private func fetchParkings(location: CLLocationCoordinate2D? , dist: Int? = nil, max: Int? = nil, completion :@escaping (Result<[ParkingLot]>)->Void){
        
        var parameters: Parameters = ["format": "json"]//This will be your parameter
        parameters["lat"] = location?.latitude
        parameters["long"] = location?.longitude
        parameters["dist"] = dist
        parameters["max"] = max
        let headers =  ["Authorization": "Bearer " + token!.accessToken]
        
        Alamofire.request("https://api.vasttrafik.se/spp/v3/parkings", method: .get, parameters: parameters, headers: headers ).response { response in
//            print(response.request)
//            print(response.response)
//            print(response.data)
//            print(response.error)
            let string = String(decoding: response.data!, as: UTF8.self)
    
            let decoder = JSONDecoder()
            do {
                let parkingAreas = try decoder.decode([ParkingArea].self, from: response.data!)
                var parkings = [ParkingLot]()
                parkingAreas.forEach{ parkingArea in
                    parkingArea.parkingLots.forEach{ parkingLot in
                        parkings.append(parkingLot)
                    }
                }
                parkings.sort {
            
                        let location0 = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon)
                        let location1 = CLLocationCoordinate2D(latitude: $1.lat, longitude: $1.lon)
                    if (location0 != nil && location1 != nil && location != nil){
                        return location0.distance(from: location!) < location1.distance(from: location!)
                    } else {
                        return false
                    }
               }
                let result = Result.success(parkings)
                completion(result)
            } catch {
                
            }
        }
    }
    func getParkings(location: CLLocationCoordinate2D?, dist: Int? = nil, max: Int? = nil, completion :@escaping (Result<[ParkingLot]>)->Void){
        
        if (isTokenValid()) {
            self.fetchParkings(location: location, dist: dist, max: max, completion: completion)
        } else {
            getToken(completion: { response in
                self.fetchParkings(location: location, dist: dist, max: max, completion: completion)
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
extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
