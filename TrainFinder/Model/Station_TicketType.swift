//
//  Station_TicketType.swift
//  BusFinder
//
//  Created by user on 2021/3/23.
//

import Foundation

struct Station_TicketType: Codable {
    let destinationStationID : String
    let destinationStationName : DestinationStationName?
    let direction : Int
    let fares : [Fare]?
    let originStationID : String
    let originStationName : DestinationStationName?
    let updateTime : String
    let versionID : Int
    enum CodingKeys: String, CodingKey {
        case destinationStationID = "DestinationStationID"
        case destinationStationName = "DestinationStationName"
        case direction = "Direction"
        case fares = "Fares"
        case originStationID = "OriginStationID"
        case originStationName = "OriginStationName"
        case updateTime = "UpdateTime"
        case versionID = "VersionID"
    }
}

struct Fare : Codable {
    let price : Int
    let ticketType : String
    enum CodingKeys: String, CodingKey {
        case price = "Price"
        case ticketType = "TicketType"
    }
}

struct DestinationStationName : Codable {
    let en : String
    let zhTw : String
    enum CodingKeys: String, CodingKey {
        case en = "En"
        case zhTw = "Zh_tw"
    }
}


struct Thsr_TicketType: Codable {
    let destinationStationID : String
    let destinationStationName : DestinationStationName?
    let direction : Int
    let fares : [ThsrFare]?
    let originStationID : String
    let originStationName : DestinationStationName?
    let updateTime : String
    let versionID : Int
    enum CodingKeys: String, CodingKey {
        case destinationStationID = "DestinationStationID"
        case destinationStationName = "DestinationStationName"
        case direction = "Direction"
        case fares = "Fares"
        case originStationID = "OriginStationID"
        case originStationName = "OriginStationName"
        case updateTime = "UpdateTime"
        case versionID = "VersionID"
    }
}

struct ThsrFare : Codable {
    let cabinClass : Int
    let fareClass : Int
    let price : Int
    let ticketType : Int
    enum CodingKeys: String, CodingKey {
        case cabinClass = "CabinClass"
        case fareClass = "FareClass"
        case price = "Price"
        case ticketType = "TicketType"
    }
}
