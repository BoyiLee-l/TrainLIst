//
//  SerachVC.swift
//  BusFinder
//
//  Created by user on 2021/3/17.
//

import UIKit
import SnapKit

enum Seats {
    case 所有車種
    case 非對號座
    case 對號座
}

class TraVc: UIViewController {
    
    struct apiData{
        var city: String
        var station: String
        var id: String
    }
    
    //MARK: - Properties
    @IBOutlet weak var startStation: UITextField!
    @IBOutlet weak var endStation: UITextField!
    @IBOutlet weak var dataText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var mySegment: UISegmentedControl!
    @IBOutlet weak var searchBtn: UIButton!
    
    let textFields:[Int] = [1001,1002,1003,1004]
    var stationPicker = UIPickerView()
    var datePicker = UIDatePicker()
    var dateBgView = UIView()
    var pickBgView = UIView()
//    var pickImageView = UIImageView()
    
    var originStationID = ""
    var originStationName = ""
    var destinationStationID = ""
    var destinationStationName = ""
    var trainDate = ""
    
    var choseSeat: Seats = .所有車種
    let fullScreenSize = UIScreen.main.bounds.size
    
    var stationList : [apiData] = []
    
    var cityList = [String]()
    var pickArr = [String : [(station: String, id: String)]]()
    
    var cityName = "基隆市"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainType = .台鐵
        configureUI()
        requestData()
    }
    
    func configureUI() {
        ShareView.shared.setBackground(view: view)
        
        searchBtn.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.5764705882, blue: 0.5411764706, alpha: 1)
        
        mySegment.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.3568627451, blue: 0.3568627451, alpha: 1)
        mySegment.tintColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8392156863, alpha: 1)
        
        configureNavigantionBar()
        
        configureTextFields()
    }
    
    func configureNavigantionBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.5764705882, blue: 0.5411764706, alpha: 1)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "台鐵時刻搜尋"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
     
    }
    
    //MARK:textFields設定
    func configureTextFields() {
        startStation.addTarget(self, action: #selector(stationTarget), for: .touchDown)
        endStation.addTarget(self, action: #selector(stationTarget), for: .touchDown)
        dataText.addTarget(self, action: #selector(dateTarget), for: .touchDown)
        timeText.addTarget(self, action: #selector(dateTarget), for: .touchDown)
        startStation.tag = 1001
        endStation.tag = 1002
        dataText.tag = 1003
        timeText.tag = 1004
        for textF in textFields {
            if let tf = self.view.viewWithTag(textF) as? UITextField {
                tf.textAlignment = .center
                tf.borderStyle = .roundedRect
                tf.layer.borderColor = UIColor.black.cgColor
                tf.layer.borderWidth = 1
                tf.layer.cornerRadius = 5
                tf.delegate = self
            }
        }
    }
    
    //MARK: 建立pickview
    @objc func stationTarget(textField: UITextField) {
        pickBgView.removeFromSuperview()
        datePicker.removeFromSuperview()
        dateBgView.removeFromSuperview()
        //建立pickerview時 縣市名稱都先初始為第一個縣市
//        cityName = "基隆市"
        // 建立 UIPickerView 設置位置及尺寸
//        stationPicker = UIPickerView(frame: CGRect(
//                                        x: fullScreenSize.width * 0.05, y: fullScreenSize.height * 0.3,
//                                        width: fullScreenSize.width * 0.9, height: fullScreenSize.height * 0.35))
        pickBgView = UIView(frame: CGRect(
                                x: fullScreenSize.width * 0.05, y: fullScreenSize.height * 0.32,
                                width: fullScreenSize.width * 0.9, height: fullScreenSize.height * 0.45))

        stationPicker.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.5764705882, blue: 0.5411764706, alpha: 1)
        
        // 設定 UIPickerView 的 delegate 及 dataSource
        stationPicker.delegate = self
        stationPicker.dataSource = self
        
        if startStation.text == "" || endStation.text == "" {
            if startStation.isEditing == false {
                startStation.text = pickArr[cityName]?[0].station
                originStationID = pickArr[cityName]?[0].id ?? ""
                originStationName = pickArr[cityName]?[0].station ?? ""
            } else {
                endStation.text = pickArr[cityName]?[0].station
                destinationStationID = pickArr[cityName]?[0].id ?? ""
                destinationStationName = pickArr[cityName]?[0].station ?? ""
            }
        }
        // 加入到畫面
        self.view.addSubview(pickBgView)
        self.pickBgView.addSubview(stationPicker)
        
        stationPicker.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    //MARK: 建立datepick
    @objc func dateTarget(textField: UITextField) {
        datePicker.removeFromSuperview()
        pickBgView.removeFromSuperview()
        dateBgView.removeFromSuperview()
        datePicker = UIDatePicker(frame: CGRect(
                                    x: 10, y: 0,
                                    width: fullScreenSize.width * 0.9, height: fullScreenSize.height * 0.35))
        dateBgView = UIView(frame: CGRect(
                            x: fullScreenSize.width * 0.05, y: fullScreenSize.height * 0.33,
                            width: fullScreenSize.width * 0.9, height: fullScreenSize.height * 0.55))
        
        dateBgView.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.5764705882, blue: 0.5411764706, alpha: 1)
        datePicker.tintColor = #colorLiteral(red: 0.4352941176, green: 0.3568627451, blue: 0.3568627451, alpha: 1)
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        datePicker.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        //設定初始化以當日時間
        if dataText.text == "" && timeText.text == "" {
            configureDate()
        }
        self.view.addSubview(dateBgView)
        self.dateBgView.addSubview(datePicker)
    }
    
    //MARK:將日期轉字串顯示
    func configureDate() {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        let timeformatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        timeformatter.dateFormat = "HH:mm:ss"
        // 更新 text 的內容
        dataText.text = formatter.string(from: datePicker.date)
        trainDate = formatter.string(from: datePicker.date)
        timeText.text = timeformatter.string(from: datePicker.date)
    }
    
    //MARK:更換日期方法
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        configureDate()
    }
    
    //MARK:手勢點擊
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickBgView.removeFromSuperview()
        datePicker.removeFromSuperview()
        dateBgView.removeFromSuperview()
    }
    
    //MARK: 撈取api
    func requestData() {
        ShareView.shared.startLoading()
        guard let url = URL(string: Information) else { return }
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode([Station_Information].self, from: data)
                var snameList = [String]()
                //MARK:撈取資料裝進陣列
                for r in result {
                    snameList.append(r.stationName?.zhTw ?? "")
                    self.cityList.append(r.locationCity)
                    self.stationList.append(apiData(city: r.locationCity, station: r.stationName?.zhTw ?? "", id: r.stationID))
                }
                //MARK:整理陣列資料格式
                let group = Array(Dictionary(grouping: self.stationList){$0.city}.values)
                self.cityList = NSOrderedSet(array: self.cityList).array as! [String]
                
                for city in group{
                    var arr = [(station: String, id: String)]()
                    var c = String()
                    for station in city{
                        c = station.city
                        arr.append((station.station, station.id))
                    }
                    self.pickArr[c] = arr
                }
//                print(self.pickArr)
                DispatchQueue.main.async {
                    ShareView.shared.stopLoading()
                    print(self.cityList.count)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if startStation.text != "" && endStation.text != "" && dataText.text != "" {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "StationVC") as? StationVC {
                vc.destinationStationID = self.destinationStationID
                vc.originStationID = self.originStationID
                vc.trainDate = self.trainDate
                vc.originStationName = self.originStationName
                vc.choseSeat = self.choseSeat
                vc.destinationStationName = self.destinationStationName
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            alert(title: "資料不完整", message: "請檢查是否選擇完成")
        }
    }
    
    @IBAction func changeSeats(_ sender: Any) {
        if mySegment.selectedSegmentIndex == 0{
            choseSeat = .所有車種
        } else if mySegment.selectedSegmentIndex == 1 {
            choseSeat = .非對號座
        } else {
            choseSeat = .對號座
        }
    }
    
}

extension TraVc: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cityList.count
        }
        return pickArr[cityName]?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return cityList[row]
        }
        return pickArr[cityName]?[row].station
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            cityName = cityList[row]
            if startStation.isEditing == true {
                startStation.text = pickArr[cityName]?[0].station
                originStationID = pickArr[cityName]?[0].id ?? ""
                originStationName = pickArr[cityName]?[0].station ?? ""
            } else {
                endStation.text = pickArr[cityName]?[0].station
                destinationStationID = pickArr[cityName]?[0].id ?? ""
                destinationStationName = pickArr[cityName]?[0].station ?? ""
            }
            pickerView.reloadAllComponents()
        } else {
            if startStation.isEditing == true {
                startStation.text = pickArr[cityName]?[row].station
                originStationID = pickArr[cityName]?[row].id ?? ""
                originStationName = pickArr[cityName]?[row].station ?? ""
            } else {
                endStation.text = pickArr[cityName]?[row].station
                destinationStationID = pickArr[cityName]?[row].id ?? ""
                destinationStationName = pickArr[cityName]?[row].station ?? ""
            }
        }
    }
}
extension TraVc: UITextFieldDelegate {
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return false
    //    }
}
