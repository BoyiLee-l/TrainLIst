//
//  StopTimeVC.swift
//  BusFinder
//
//  Created by user on 2021/3/25.
//

import UIKit

class StopTimeVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var myTableView: UITableView!
    var dataList = [StopTime]()
    var trainNO = ""
    var trainDate = ""
    
    //MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTable()
        request()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        request()
    }
    
    func configureUI() {
        ShareView.shared.setBackground(view: view)
        self.navigationItem.title = trainNO
    }
    
    //MARK:設定table
    func setTable() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = .clear
        myTableView.register(UINib(nibName: "StopTimeCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //MARK:判斷資料裝進物件
    func request() {
        ShareView.shared.startLoading()
        
            ServerCommunicator.shared.loadStopStation(newTrainTypeStr: newTrainTypeStr,
                                                  trainNO: self.trainNO,
                                                  trainDate: self.trainDate) { data in
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
        cell.setupData()
        //下條件撈出到達時間 大於 現在時間
        let result = dataList.filter { (i) -> Bool in
            return cell.time <= ShareView.shared.timeToTimeStamp(time: i.arrivalTime)
        }
        //在跟陣列中時間比對 <= 最接近的到達時間
        if cellData.arrivalTime ==  result.first?.arrivalTime ?? "" {
            cell.myGif.loadGif(name: "train2")
            cell.stationNameLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else if ShareView.shared.timeToTimeStamp(time:cellData.departureTime) <= cell.time {
            cell.myGif.image = UIImage(named: "pass")
            cell.stationNameLabel.textColor = #colorLiteral(red: 0.04386587473, green: 0.7064148036, blue: 0.3536839813, alpha: 1)
        } else {
            cell.myGif.image = UIImage(named: "")
            cell.stationNameLabel.textColor = #colorLiteral(red: 0.05110876679, green: 0.2072706686, blue: 0.7945691506, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
