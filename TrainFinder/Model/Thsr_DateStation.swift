//
//  Hsr_DateStation.swift
//  TrainFinder
//
//  Created by user on 2021/9/24.
//

import Foundation

struct Thsr_DateStation: Codable {
    let dailyTrainInfo : ThsrDailyTrainInfo?
    let destinationStopTime : ThsrDestinationStopTime?
    let originStopTime : ThsrDestinationStopTime?
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

struct ThsrDestinationStopTime : Codable {
    let arrivalTime : String?
    let departureTime : String?
    let stationID : String?
    let stationName : ThsrEndingStationName?
    let stopSequence : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case arrivalTime = "ArrivalTime"
        case departureTime = "DepartureTime"
        case stationID = "StationID"
        case stationName = "StationName"
        case stopSequence = "StopSequence"
    }
}

struct ThsrDailyTrainInfo : Codable {
    let direction : Int?
    let endingStationID : String?
    let endingStationName : ThsrEndingStationName?
    let startingStationID : String?
    let startingStationName : ThsrEndingStationName?
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

struct ThsrEndingStationName : Codable {
    let en : String?
    let zhTw : String?

    enum CodingKeys: String, CodingKey {
        case en = "En"
        case zhTw = "Zh_tw"
    }
}
