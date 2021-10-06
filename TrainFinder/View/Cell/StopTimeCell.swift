//
//  StopTimeCell.swift
//  BusFinder
//
//  Created by user on 2021/3/25.
//

import UIKit

class StopTimeCell: UITableViewCell {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    
    @IBOutlet weak var departureTimeLabel: UILabel!
    
    @IBOutlet weak var myGif: UIImageView!
    
    var dataList = [StopTime]()
    
    var cellData: StopTime?
    
    var trainToday = true
    
    let time = ShareView.shared.timeToTimeStamp(time: ShareView.shared.nowTime())
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .clear
        
        stationNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        arrivalTimeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        departureTimeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        arrivalTimeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        departureTimeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func setupData() {
        
        stationNameLabel.text = cellData?.stationName?.zhTw
        arrivalTimeLabel.text = cellData?.arrivalTime
        departureTimeLabel.text = cellData?.departureTime
        //print(time, doubleArrival, doubleDepartue)
        
        //如果查詢日期適當日在做下面步驟
        if trainToday == true {
            //下條件撈出到達時間 大於 現在時間
            let result = dataList.filter { (i) -> Bool in
                return self.time <= ShareView.shared.timeToTimeStamp(time: i.arrivalTime)
            }
            //在跟陣列中時間比對 <= 最接近的到達時間
            if cellData?.arrivalTime ==  result.first?.arrivalTime ?? "" {
                self.myGif.loadGif(name: "train2")
                self.stationNameLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                
            } else if ShareView.shared.timeToTimeStamp(time:cellData?.departureTime ?? "") <= self.time {
                self.myGif.image = UIImage(named: "pass")
                self.stationNameLabel.textColor = #colorLiteral(red: 0.04386587473, green: 0.7064148036, blue: 0.3536839813, alpha: 1)
            } else {
                self.myGif.image = UIImage(named: "")
                self.stationNameLabel.textColor = #colorLiteral(red: 0.05110876679, green: 0.2072706686, blue: 0.7945691506, alpha: 1)
            }
        } else {
            self.myGif.image = UIImage(named: "")
            self.stationNameLabel.textColor = #colorLiteral(red: 0.05110876679, green: 0.2072706686, blue: 0.7945691506, alpha: 1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
