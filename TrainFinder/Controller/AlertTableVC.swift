//
//  priceTableVC.swift
//  BusFinder
//
//  Created by user on 2021/3/23.
//

import UIKit

class AlertTableVC: UITableViewController {
    var size:CGSize?
    var dataList = [Fare]()
    var OriginStationID = ""
    var DestinationStationID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        request()
    }
    
    func configureTable() {
        ShareView.shared.setBackground(view: view)
        size = CGSize(width: 272, height: 280)
        self.preferredContentSize = size!
        self.tableView.register(UINib(nibName: "AlertViewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //MARK:撈api資料
    func loadData(complete: @escaping([Station_TicketType]) -> Void) {
        let DateStation = "https://ptx.transportdata.tw/MOTC/v2/Rail/\(newTrainTypeStr)/ODFare/\(OriginStationID)/to/\(DestinationStationID)?$top=30&$format=JSON"
        
        guard let url = URL(string: DateStation) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Station_TicketType].self, from: data)
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
        loadData { (data) in
            if data.isEmpty {
                DispatchQueue.main.async {
                    self.alert(title: "查無相關票價", message: "該班車可能無售票")
                }
            } else {
                self.dataList = data.first?.fares ?? []
                print("有資料:", self.dataList)
            }
            DispatchQueue.main.async {
                ShareView.shared.stopLoading()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlertViewTableViewCell
        cell.ticketType.text = dataList[indexPath.row].ticketType
        cell.price.text = String(dataList[indexPath.row].price)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
