//
//  Hsr_DateStation.swift
//  TrainFinder
//
//  Created by user on 2021/9/24.
//

import Foundation

struct Thsr_DateStation: Codable {
    let dailyTrainInfo : HsrDailyTrainInfo?
    let destinationStopTime : HsrDestinationStopTime?
    let originStopTime : HsrDestinationStopTime?
    let trainDate : String?
    let updateTime : String?
    let versionID : Int?
    
    enum CodingKeys: String, CodingKey {
        case dailyTrainInfo = "DailyTrainInfo"
        case destinationStopTime = "DestinationStopTime"
        case originStopTime = "OriginStopTime"
        case trainDate = "TrainDate"
        case updateTime = "UpdateTime"
        case versionID = "VersionID"
    }
}

struct HsrDestinationStopTime : Codable {
    let arrivalTime : String?
    let departureTime : String?
    let stationID : String?
    let stationName : HsrEndingStationName?
    let stopSequence : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case arrivalTime = "ArrivalTime"
        case departureTime = "DepartureTime"
        case stationID = "StationID"
        case stationName = "StationName"
        case stopSequence = "StopSequence"
    }
}

struct HsrDailyTrainInfo : Codable {
    let direction : Int?
    let endingStationID : String?
    let endingStationName : HsrEndingStationName?
    let startingStationID : String?
    let startingStationName : HsrEndingStationName?
    let trainNo : String?
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case endingStationID = "EndingStationID"
        case endingStationName = "EndingStationName"
        case startingStationID = "StartingStationID"
        case startingStationName = "StartingStationName"
        case trainNo = "TrainNo"
    }
}

struct HsrEndingStationName : Codable {
    let en : String?
    let zhTw : String?

    enum CodingKeys: String, CodingKey {
        case en = "En"
        case zhTw = "Zh_tw"
    }
}
