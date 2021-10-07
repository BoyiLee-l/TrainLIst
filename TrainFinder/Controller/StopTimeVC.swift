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
    
    //判斷是不是搜尋當天列車
    var choseDate: SearchDate = .當天
    
    //MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTable()
        request()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    func configureUI() {
//        ShareView.shared.setBackground(view: view)
        self.navigationItem.title = trainNO
        print(self.choseDate)
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
        cell.cellData = cellData
        cell.dataList = self.dataList
        cell.choseDate = self.choseDate
        cell.setupData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
