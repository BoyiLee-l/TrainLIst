//
//  priceTableVC.swift
//  BusFinder
//
//  Created by user on 2021/3/23.
//

import UIKit

class AlertTableVC: UITableViewController {
    var size:CGSize?
    var traDataList = [Fare]()
    var thsrDataList = [ThsrFare]()
    var OriginStationID = ""
    var DestinationStationID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        request()
        print("trainType:",trainType)
    }
    
    func configureTable() {
        ShareView.shared.setBackground(view: view)
        size = CGSize(width: 272, height: 280)
        self.preferredContentSize = size!
        self.tableView.register(UINib(nibName: "AlertViewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //MARK:撈api資料
    //台鐵
    func loadTraData(complete: @escaping([Station_TicketType]) -> Void) {
        let DateStation = "https://ptx.transportdata.tw/MOTC/v2/Rail/\(newTrainTypeStr)/ODFare/\(OriginStationID)/to/\(DestinationStationID)?$top=30&$format=JSON"
        
        guard let url = URL(string: DateStation) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        print("列車資料", request)
        print("Authorization",  authorization)
        print("x-date",xdate)
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
    
    //高鐵
    func loadThsrData(complete: @escaping([Thsr_TicketType]) -> Void) {
        let DateStation = "https://ptx.transportdata.tw/MOTC/v2/Rail/\(newTrainTypeStr)/ODFare/\(OriginStationID)/to/\(DestinationStationID)?$top=30&$format=JSON"
        
        guard let url = URL(string: DateStation) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        print("列車資料", request)
        print("Authorization",  authorization)
        print("x-date",xdate)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else { return }
            do {
                let result = try JSONDecoder().decode([Thsr_TicketType].self, from: data)
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
        
        switch trainType {
        case .台鐵:
            loadTraData { (data) in
                if data.isEmpty {
                    DispatchQueue.main.async {
                        self.alert(title: "查無相關票價", message: "該班車可能無售票")
                    }
                } else {
                    self.traDataList = data.first?.fares ?? []
                    print("有資料:", self.traDataList)
                }
                DispatchQueue.main.async {
                    ShareView.shared.stopLoading()
                    self.tableView.reloadData()
                }
            }
        case .高鐵:
            loadThsrData { (data) in
                if data.isEmpty {
                    DispatchQueue.main.async {
                        self.alert(title: "查無相關票價", message: "該班車可能無售票")
                    }
                } else {
                    self.thsrDataList = data.first?.fares ?? []
                    print("有資料:", self.thsrDataList)
                }
                DispatchQueue.main.async {
                    ShareView.shared.stopLoading()
                    self.tableView.reloadData()
                }
            }
        }
    }
    //車廂費率
    func cabinClass(typeNum: Int) -> String {
        switch typeNum{
        case 1:
            return "標準座"
        case 2:
            return "商務座"
        default:
            return "自由座"
        }
    }
    //年紀費率
    func fareClass(typeNum: Int) -> String {
        switch typeNum{
        case 1:
            return "成人"
        case 2:
            return "學生"
        case 3:
            return "孩童"
        case 4:
            return "敬老"
        case 5:
            return "愛心"
        case 6:
            return "愛心孩童"
        case 7:
            return "愛心優待"
        case 8:
            return "軍警"
        default:
            return "法優"
        }
    }
    //票種類型
    func ticketTypeClass(typeNum: Int) -> String {
        switch typeNum{
        case 1:
            return "單程票"
        case 2:
            return "來回票"
        case 3:
            return "電子票証"
        case 4:
            return "回數票"
        case 5:
            return "定期票(30天期)"
        case 6:
            return "定期票(60天期)"
        case 7:
            return "早鳥票"
        default:
            return "團體票"
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch trainType {
        case .台鐵:
            return 40
        case .高鐵:
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch trainType {
        case .台鐵:
            return traDataList.count
        case .高鐵:
            return thsrDataList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlertViewTableViewCell
        switch trainType {
        case .台鐵:
            cell.ticketType.text = traDataList[indexPath.row].ticketType
            cell.price.text = String(traDataList[indexPath.row].price)
            return cell
        case .高鐵:
            let ticketData = thsrDataList[indexPath.row]
            cell.ticketType.text = "票種:\(ticketTypeClass(typeNum: ticketData.ticketType))\n費率:\(fareClass(typeNum: ticketData.fareClass))\n座艙:\(cabinClass(typeNum: ticketData.cabinClass))"
            cell.price.text = String(ticketData.price)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
