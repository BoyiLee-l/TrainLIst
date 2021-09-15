//
//  Station_StopTime.swift
//  BusFinder
//
//  Created by user on 2021/3/25.
//

import Foundation

struct Station_StopTime : Codable {
    let dailyTrainInfo : StopTimeDailyTrainInfo?
    let stopTimes : [StopTime]
    let trainDate : String
    let updateTime : String
    let versionID : Int
    
    enum CodingKeys: String, CodingKey {
        case dailyTrainInfo = "DailyTrainInfo"
        case stopTimes = "StopTimes"
        case trainDate = "TrainDate"
        case updateTime = "UpdateTime"
        case versionID = "VersionID"
    }
}

struct StopTime : Codable {
    let arrivalTime : String
    let departureTime : String
    let stationID : String
    let stationName : StopTimeStationName?
    let stopSequence : Int
    
    enum CodingKeys: String, CodingKey {
        case arrivalTime = "ArrivalTime"
        case departureTime = "DepartureTime"
        case stationID = "StationID"
        case stationName = "StationName"
        case stopSequence = "StopSequence"
    }
}

struct StopTimeDailyTrainInfo : Codable {
    let bikeFlag : Int
    let breastFeedingFlag : Int
    let dailyFlag : Int
    let diningFlag : Int
    let direction : Int
    let endingStationID : String
    let endingStationName : StopTimeStationName?
//    let overNightStationID : String
    let packageServiceFlag : Int
    let serviceAddedFlag : Bool
    let startingStationID : String
    let startingStationName : StopTimeStationName?
    let trainNo : String
    let trainTypeCode : String
    let trainTypeID : String
    let trainTypeName : StopTimeStationName?
    let tripHeadsign : String
    let tripLine : Int
    let wheelchairFlag : Int
    
    enum CodingKeys: String, CodingKey {
        case bikeFlag = "BikeFlag"
        case breastFeedingFlag = "BreastFeedingFlag"
        case dailyFlag = "DailyFlag"
        case diningFlag = "DiningFlag"
        case direction = "Direction"
        case endingStationID = "EndingStationID"
        case endingStationName = "EndingStationName"
//        case overNightStationID = "OverNightStationID"
        case packageServiceFlag = "PackageServiceFlag"
        case serviceAddedFlag = "ServiceAddedFlag"
        case startingStationID = "StartingStationID"
        case startingStationName = "StartingStationName"
        case trainNo = "TrainNo"
        case trainTypeCode = "TrainTypeCode"
        case trainTypeID = "TrainTypeID"
        case trainTypeName = "TrainTypeName"
        case tripHeadsign = "TripHeadsign"
        case tripLine = "TripLine"
        case wheelchairFlag = "WheelchairFlag"
    }
}

struct StopTimeStationName : Codable {
    let en : String
    let zhTw : String
    
    enum CodingKeys: String, CodingKey {
        case en = "En"
        case zhTw = "Zh_tw"
    }
}
