//
//  ServerURL.swift
//  BusFinder
//
//  Created by user on 2021/3/8.
//
//


import Foundation
import CommonCrypto
import CryptoKit

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

enum TrainType {
    case 台鐵
    case 高鐵
}

var trainType: TrainType = .台鐵 {
    didSet {
        if trainType == .台鐵 {
            Information = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/Station?$format=JSON"
            newTrainTypeStr = "TRA"
        } else {
            Information = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/Station?$format=JSON"
            newTrainTypeStr = "THSR"
        }
    }
}
//台鐵,高鐵型態變數
var newTrainTypeStr = "TRA"

//鐵路基本資料api網址
var Information = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/Station?$format=JSON"

let APP_ID = "0c9ad3c533b048f28c94ad79974481de"
let APP_KEY = "JJCm4gIjuobzDW3-A9uX5Iaw-4Y"

let xdate:String = getServerTime()

let signDate = "x-date: " + xdate

@available(iOS 13.0, *)
let key = SymmetricKey(data: Data(APP_KEY.utf8))

@available(iOS 13.0, *)
let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)

let base64HmacStr = signDate.hmac(algorithm: .SHA1, key: APP_KEY)

let authorization:String = "hmac username=\""+APP_ID+"\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\""+base64HmacStr+"\""

let url = URL(string: Information)

let sema = DispatchSemaphore( value: 0)

var request = URLRequest(url: url!)

func getServerTime() -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
    dateFormater.locale = Locale(identifier: "en_US")
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormater.string(from: Date())
}

extension String {
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        let digestLen = algorithm.digestLength
        var result = [CUnsignedChar](repeating: 0, count: digestLen)
        CCHmac(algorithm.HMACAlgorithm, cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        let hmacData:Data = Data(bytes: result, count: digestLen)
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength64Characters)
        return String(hmacBase64)
    }
}


