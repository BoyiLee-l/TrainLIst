//
//  Station_DelayTime.swift
//  BusFinder
//
//  Created by user on 2021/3/25.
//

import Foundation

struct Station_DelayTime: Codable {
    let delayTime : Int
    let trainNo : String
    
    enum CodingKeys: String, CodingKey {
        case delayTime = "DelayTime"
        case trainNo = "TrainNo"
        
    }
}
