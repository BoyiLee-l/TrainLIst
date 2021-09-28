//
//  HsrVc.swift
//  TrainFinder
//
//  Created by user on 2021/9/16.
//

import UIKit

class ThsrVc: UIViewController {
    
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
    @IBOutlet weak var searchBtn: UIButton!
    
    let textFields:[Int] = [1001,1002,1003,1004]
    var stationPicker = UIPickerView()
    var datePicker = UIDatePicker()
    var dateBgView = UIView()
    var pickBgView = UIView()
    
    var originStationID = ""
    var originStationName = ""
    var destinationStationID = ""
    var destinationStationName = ""
    var trainDate = ""
    
    let fullScreenSize = UIScreen.main.bounds.size
    var stationList : [apiData] = []
    
    var pickRow = 0
    //    var cityList = [String]()
    //    var pickArr = [String : [(station: String, id: String)]]()
    //    var cityName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        trainType = .高鐵
        requestData()
    }
    
    func configureUI() {
        ShareView.shared.setBackground(view: view)
        
        searchBtn.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    
        configureNavigantionBar()
        
        configureTextFields()
    }
    
    func configureNavigantionBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "高鐵時刻搜尋"
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
            }
        }
    }
    
    //MARK: 建立pickview
    @objc func stationTarget(textField: UITextField) {
        pickBgView.removeFromSuperview()
        datePicker.removeFromSuperview()
        dateBgView.removeFromSuperview()
        //建立pickerview時 縣市名稱都先初始為第一個縣市
        pickBgView = UIView(frame: CGRect(
                                x: fullScreenSize.width * 0.05, y: fullScreenSize.height * 0.32,
                                width: fullScreenSize.width * 0.9, height: fullScreenSize.height * 0.45))
        
        stationPicker.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        stationPicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        // 設定 UIPickerView 的 delegate 及 dataSource
        stationPicker.delegate = self
        stationPicker.dataSource = self
        
        if startStation.text == "" || endStation.text == "" {
            if startStation.isEditing == false {
                startStation.text = stationList[pickRow].station
                originStationID = stationList[pickRow].id
                originStationName = stationList[pickRow].station
            } else {
                endStation.text = stationList[pickRow].station
                destinationStationID = stationList[pickRow].id
                destinationStationName = stationList[pickRow].station
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
        
        dateBgView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        datePicker.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
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
        print("Information:",Information)
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            //            let resString = self.dataToString(data: data)
            do {
                let result = try JSONDecoder().decode([Station_Information].self, from: data)
                
                //MARK:撈取資料裝進陣列
                for r in result {
                    self.stationList.append(apiData(city: r.locationCity, station: r.stationName?.zhTw ?? "", id: r.stationID))
                }
                
                DispatchQueue.main.async {
                    ShareView.shared.stopLoading()
                    print(self.stationList)
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
                vc.destinationStationName = self.destinationStationName
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            alert(title: "資料不完整", message: "請檢查是否選擇完成")
        }
    }
}

extension ThsrVc: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return stationList.count
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return stationList[row].station
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.pickRow = row
        if startStation.isEditing == true {
            startStation.text = stationList[row].station
            originStationID = stationList[row].id
            originStationName = stationList[row].station
        } else {
            endStation.text = stationList[row].station
            destinationStationID = stationList[row].id
            destinationStationName = stationList[row].station
        }
    }
}
