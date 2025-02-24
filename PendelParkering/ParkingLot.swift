//
// ParkingLot.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct ParkingLot: Codable {

    public var name: String
    public var totalCapacity: Int
    public var parkingType: ParkingType
    public var lat: Double
    public var _id: Int
    /** Only available if ParkingType Name is SMARTCARPARK */
    public var parkingCameras: [ParkingCamera]?
    public var lon: Double
    public var isRestrictedByBarrier: Bool
    /** Number of free spaces. Only available if ParkingType Name is SMARTCARPARK */
    public var freeSpaces: Int?

    public init(name: String, totalCapacity: Int, parkingType: ParkingType, lat: Double, _id: Int, parkingCameras: [ParkingCamera]?, lon: Double, isRestrictedByBarrier: Bool, freeSpaces: Int?) {
        self.name = name
        self.totalCapacity = totalCapacity
        self.parkingType = parkingType
        self.lat = lat
        self._id = _id
        self.parkingCameras = parkingCameras
        self.lon = lon
        self.isRestrictedByBarrier = isRestrictedByBarrier
        self.freeSpaces = freeSpaces
    }

    public enum CodingKeys: String, CodingKey { 
        case name = "Name"
        case totalCapacity = "TotalCapacity"
        case parkingType = "ParkingType"
        case lat = "Lat"
        case _id = "Id"
        case parkingCameras = "ParkingCameras"
        case lon = "Lon"
        case isRestrictedByBarrier = "IsRestrictedByBarrier"
        case freeSpaces = "FreeSpaces"
    }


}

