//
//  NetworkData.swift
//  BusFinder
//
//  Created by user on 2021/3/8.
//

import Foundation
import Alamofire

struct Resource<T: Decodable> {
    let url: URL
}

class ServerCommunicator {
    
    static let shared = ServerCommunicator()
    
    //    let sclalert = SCLAlertView()
    
    func getBusRoute<T>(resource:Resource<T>, completion: @escaping (T?) -> Void) {
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result)
            } catch {
                print(error)
                completion(nil)
            }
        }.resume()
    }
    
    //MARK:台鐵起迄站間之時刻表資料
    func loadTraData(newTrainTypeStr:String,
                     originStationID:String,
                     destinationStationID:String,
                     trainDate:String,
                     complete: @escaping([Tra_DateStation]) -> Void) {
        
        let dateStationUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/\(newTrainTypeStr)/DailyTimetable/OD/\(originStationID)/to/\(destinationStationID)/\(trainDate)?$format=JSON"
        print(dateStationUrl)
        guard let url = URL(string: dateStationUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        //車次資料
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //            print("列車資料", data)
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Tra_DateStation].self, from: data)
                if result.isEmpty {
                    complete([])
                } else {
                    complete(result)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    //                    self.sclalert.showError("系統異常", subTitle: "請稍後再嘗試")
                }
            }
        }.resume()
    }
    
    //MARK:高鐵起迄站間之時刻表資料
    func loadThsrData(newTrainTypeStr:String,
                      originStationID:String,
                      destinationStationID:String,
                      trainDate:String,
                      complete: @escaping([Thsr_DateStation]) -> Void) {
        
        let dateStationUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/\(newTrainTypeStr)/DailyTimetable/OD/\(originStationID)/to/\(destinationStationID)/\(trainDate)?$format=JSON"
        guard let url = URL(string: dateStationUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        //車次資料
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //            print("列車資料", data)
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Thsr_DateStation].self, from: data)
                if result.isEmpty {
                    complete([])
                } else {
                    complete(result)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    //                    self.sclalert.showError("系統異常", subTitle: "請稍後再嘗試")
                }
            }
        }.resume()
    }
    
    //車次停靠站
    func loadStopStation(newTrainTypeStr:String,
                     trainNO:String,
                     trainDate:String,
                     complete: @escaping([Tra_StopTime]) -> Void) {
        
        let stopTimeUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/\(newTrainTypeStr)/DailyTimetable/TrainNo/\(trainNO)/TrainDate/\(trainDate)?$top=30&$format=JSON"
        
        print("url:", stopTimeUrl)
        guard let url = URL(string: stopTimeUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Tra_StopTime].self, from: data)
                if result.isEmpty {
                    complete([])
                } else {
                    complete(result)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    //                    self.alert(title: "系統異常", message: "請稍後再嘗試")
                    ShareView.shared.stopLoading()
                }
            }
        }.resume()
    }
}
