//
// ParkingType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct ParkingType: Codable {

    public enum Name: String, Codable { 
        case carpark = "CARPARK"
        case smartcarpark = "SMARTCARPARK"
    }
    /** The parking lot type */
    public var name: Name
    public var number: Int

    public init(name: Name, number: Int) {
        self.name = name
        self.number = number
    }

    public enum CodingKeys: String, CodingKey { 
        case name = "Name"
        case number = "Number"
    }


}

