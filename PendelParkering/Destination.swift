//
// Destination.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct Destination: Codable {

    public var name: String
    public var _id: String

    public init(name: String, _id: String) {
        self.name = name
        self._id = _id
    }

    public enum CodingKeys: String, CodingKey { 
        case name = "Name"
        case _id = "Id"
    }


}

