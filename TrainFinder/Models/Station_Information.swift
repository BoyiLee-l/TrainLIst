//
//  SubRouteInfo.swift
//  BusFinder
//
//  Created by user on 2021/3/8.
//

import Foundation

struct Station_Information: Codable {
    let stationID : String
    let stationName : StationName?
    let locationCity : String
    let locationCityCode : String
    
    enum CodingKeys: String, CodingKey {
        case stationID = "StationID"
        case stationName = "StationName"
        case locationCity = "LocationCity"
        case locationCityCode = "LocationCityCode"
    }
}

struct StationName : Codable {
    let en : String
    let zhTw : String
    
    enum CodingKeys: String, CodingKey {
        case en = "En"
        case zhTw = "Zh_tw"
    }
}
