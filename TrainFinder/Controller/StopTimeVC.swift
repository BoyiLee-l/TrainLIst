//
//  StopTimeVC.swift
//  BusFinder
//
//  Created by user on 2021/3/25.
//

import UIKit

class StopTimeVC: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    var dataList = [StopTime]()
    var trainNO = ""
    var trainDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ShareView.shared.setBackground(view: view)
        setTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        request()
    }
    //MARK:設定table
    func setTable() {
        myTableView.delegate = self
        myTableView.dataSource = self
//        myTableView.backgroundColor = .clear
        myTableView.register(UINib(nibName: "StopTimeCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //MARK:撈api資料
    func loadData(complete: @escaping([Station_StopTime]) -> Void) {
        let stopTimeUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/DailyTimetable/TrainNo/\(trainNO)/TrainDate/\(trainDate)?$top=30&$format=JSON"
        print("url:", stopTimeUrl)
        guard let url = URL(string: stopTimeUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Station_StopTime].self, from: data)
                if result.isEmpty {
                    complete([])
                } else {
                    complete(result)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.alert(title: "系統異常", message: "請稍後再嘗試")
                    ShareView.shared.stopLoading()
                }
            }
        }.resume()
    }
    
    //MARK:判斷資料裝進物件
    func request() {
        ShareView.shared.startLoading()
        loadData { (data) in
            if data.isEmpty {
                DispatchQueue.main.async {
                    self.alert(title: "查無相關車次", message: "該班可能無直達車需轉乘")
                }
            } else {
                self.dataList = data.first?.stopTimes ?? []
                print("有資料:", self.dataList)
            }
            DispatchQueue.main.async {
                ShareView.shared.stopLoading()
                self.myTableView.reloadData()
            }
        }
    }
    
}
extension StopTimeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! StopTimeCell
        let cellData = dataList[indexPath.row]
        cell.data = cellData
        cell.setContent()
        //下條件撈出到達時間 大於 現在時間
        let result = dataList.filter { (i) -> Bool in
            return cell.time <= ShareView.shared.timeToTimeStamp(time: i.arrivalTime)
        }
        //在跟陣列中時間比對 <= 最接近的到達時間
        if cellData.arrivalTime ==  result.first?.arrivalTime ?? "" {
            cell.myGif.loadGif(name: "train2")
        } else if ShareView.shared.timeToTimeStamp(time:cellData.departureTime) < cell.time {
            cell.myGif.image = UIImage(named: "pass")
        } else {
            cell.myGif.image = UIImage(named: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
