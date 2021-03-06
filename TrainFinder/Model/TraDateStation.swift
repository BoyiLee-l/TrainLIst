//
//  DateStation.swift
//  BusFinder
//
//  Created by user on 2021/3/22.
//

import Foundation

struct TraDateStation : Codable {
    let dailyTrainInfo : TraDailyTrainInfo?
    let destinationStopTime : TraDestinationStopTime?
    let originStopTime : TraDestinationStopTime?
    let trainDate : String?
    let versionID : Int?
    
    enum CodingKeys: String, CodingKey {
        case dailyTrainInfo = "DailyTrainInfo"
        case destinationStopTime = "DestinationStopTime"
        case originStopTime = "OriginStopTime"
        case trainDate = "TrainDate"
        case versionID = "VersionID"
    }
}

struct TraDestinationStopTime : Codable {
    let arrivalTime : String
    let departureTime : String
    let stationID : String
    let stationName : TraEndingStationName?
    let stopSequence : Int
    
    enum CodingKeys: String, CodingKey {
        case arrivalTime = "ArrivalTime"
        case departureTime = "DepartureTime"
        case stationID = "StationID"
        case stationName = "StationName"
        case stopSequence = "StopSequence"
    }
}

struct TraDailyTrainInfo : Codable {
    let bikeFlag : Int
    let breastFeedingFlag : Int
    let dailyFlag : Int
    let diningFlag : Int
    let direction : Int
    let endingStationID : String
    let endingStationName : TraEndingStationName?
    let packageServiceFlag : Int
    let serviceAddedFlag : Bool
    let startingStationID : String
    let startingStationName : TraEndingStationName?
    let trainNo : String
    let trainTypeCode : String
    let trainTypeID : String
    let trainTypeName : TraEndingStationName?
//    let tripHeadsign : String
//    let tripLine : Int
//    let wheelchairFlag : Int
    
    enum CodingKeys: String, CodingKey {
        case bikeFlag = "BikeFlag"
        case breastFeedingFlag = "BreastFeedingFlag"
        case dailyFlag = "DailyFlag"
        case diningFlag = "DiningFlag"
        case direction = "Direction"
        case endingStationID = "EndingStationID"
        case endingStationName = "EndingStationName"
        case packageServiceFlag = "PackageServiceFlag"
        case serviceAddedFlag = "ServiceAddedFlag"
        case startingStationID = "StartingStationID"
        case startingStationName = "StartingStationName"
        case trainNo = "TrainNo"
        case trainTypeCode = "TrainTypeCode"
        case trainTypeID = "TrainTypeID"
        case trainTypeName = "TrainTypeName"
//        case tripHeadsign = "TripHeadsign"
//        case tripLine = "TripLine"
//        case wheelchairFlag = "WheelchairFlag"
    }
}

struct TraEndingStationName : Codable {
    let en : String
    let zhTw : String
    
    enum CodingKeys: String, CodingKey {
        case en = "En"
        case zhTw = "Zh_tw"
    }
}
