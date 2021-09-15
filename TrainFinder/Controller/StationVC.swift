//
//  ViewController.swift
//  BusFinder
//
//  Created by user on 2021/3/8.
//

import UIKit

//自創資料格式
struct newTrainData {
    var trainNo = ""
    var trainTypeName = ""
    var arrivalTime = ""
    var departureTime = ""
    var delayTime = 0
}

class StationVC: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var priceBtn: UIButton!
    //裝本來列車資料用
    var dataList = [Station_DateStation]()
    //裝延遲時間用
    var dealyDic = [String : Int]()
    //新建資料格式用
    var newDataList: [newTrainData] = []
    
    var choseSeat: Seats = .所有車種
    var spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityView.style = .large
        } else {
            // Fallback on earlier versions
        }
        return activityView
    }()
    
    var originStationID = ""
    var originStationName = ""
    var destinationStationID = ""
    var destinationStationName = ""
    var trainDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        ShareView.shared.setBackground(view: view)
        interfaceInitialization()
        request()
        setTableView()
        //print("給點回應", newDataList)
        print("座位類別", choseSeat)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setTableView() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
        //        myTableView.backgroundColor = .clear
    }
    //MARK:元件初始化
    func interfaceInitialization() {
        ShareView.shared.setupActivityView(view: view)
        self.navigationItem.title = "\(originStationName) - \(destinationStationName)"
        priceBtn.setTitle("查詢票價", for: .normal)
    }
    
    //MARK:撈列車api資料
    func loadData(complete: @escaping([Station_DateStation]) -> Void) {
        let DateStationUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/DailyTimetable/OD/\(originStationID)/to/\(destinationStationID)/\(trainDate)?&$format=JSON"
        guard let url = URL(string: DateStationUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        //車次資料
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Station_DateStation].self, from: data)
                if result.isEmpty {
                    complete([])
                } else {
                    complete(result)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.alert(title: "系統異常", message: "請稍後再嘗試")
                }
            }
        }.resume()
    }
    
    //MARK:撈延遲時間api資料
    func loadTimeData(complete: @escaping([Station_DelayTime]) -> Void) {
        let DateStationUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveTrainDelay?$select=TrainNo&$format=JSON"
        guard let url = URL(string: DateStationUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        //車次資料
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Station_DelayTime].self, from: data)
                if result.isEmpty {
                    complete([])
                } else {
                    complete(result)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.alert(title: "系統異常", message: "請稍後再嘗試")
                }
            }
        }.resume()
    }
    
    //MARK:判斷資料裝進物件
    func request() {
        ShareView.shared.startLoading()
        let group: DispatchGroup = DispatchGroup()
        let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
        group.enter()
        queue1.async(group: group) {
            self.loadData { (data) in
                if data.isEmpty {
                    DispatchQueue.main.async {
                        self.alert(title: "查無相關車次", message: "該班可能無直達車需轉乘")
                    }
                } else {
                    switch self.choseSeat {
                    case .對號座:
                        let newdata =  data.filter { ($0.dailyTrainInfo?.trainTypeID != "1131"  && $0.dailyTrainInfo?.trainTypeID != "1132") }
                        self.dataList = newdata
                        print("給點回應", self.dataList)
                        break
                    case .非對號座:
                        let newdata =  data.filter { ($0.dailyTrainInfo?.trainTypeID == "1131"  || $0.dailyTrainInfo?.trainTypeID == "1132") }
                        self.dataList = newdata
                        print("給點回應", self.dataList)
                        break
                    case .所有車種:
                        self.dataList = data
                        break
                    }
                }
                // 結束呼叫 API1
                group.leave()
                DispatchQueue.main.async {
                    ShareView.shared.stopLoading()
                    self.myTableView.reloadData()
                }
            }
        }
        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
        group.enter() // 開始呼叫 API2
        queue2.async(group: group) {
            //在查完相關車次後加入延遲時間api
            self.loadTimeData { (timeData) in
                for time in timeData {
                    //將資料裝入自創字典
                    self.dealyDic[time.trainNo] = time.delayTime
                }
                print(self.dealyDic)
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            //將整理後資料加入新建立資料格式
            for newData in self.dataList {
                self.newDataList.append(newTrainData(trainNo: newData.dailyTrainInfo?.trainNo ?? "", trainTypeName: newData.dailyTrainInfo?.trainTypeName?.zhTw ?? "", arrivalTime: newData.originStopTime?.arrivalTime ?? "", departureTime: newData.destinationStopTime?.departureTime ?? "", delayTime: self.dealyDic[newData.dailyTrainInfo?.trainNo ?? ""] ?? 0))
            }
            print(self.newDataList)
        }
    }
    
    @IBAction func priceAction(_ sender: Any) {
        let tableVC = AlertTableVC()
        tableVC.OriginStationID = self.originStationID
        tableVC.DestinationStationID = self.destinationStationID
        let alertController = UIAlertController(title: "車票價目表", message: "", preferredStyle: .alert)
        alertController.setValue(tableVC, forKey: "contentViewController")
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension StationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        let cellData = newDataList[indexPath.row]
        cell.data = cellData
        cell.setContent()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "StopTimeVC") as? StopTimeVC {
            vc.trainNO = self.dataList[indexPath.row].dailyTrainInfo?.trainNo ?? ""
            vc.trainDate = self.trainDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}