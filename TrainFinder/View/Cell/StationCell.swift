//
//  StationCell.swift
//  BusFinder
//
//  Created by user on 2021/3/17.
//

import UIKit

class StationCell: UITableViewCell {
    
    @IBOutlet weak var trainTypeName: UILabel!
    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var delayTime: UILabel!
    var data: newTrainData?
    var trainToday = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .clear
        startTime.font = UIFont.boldSystemFont(ofSize: 20)
        endTime.font = UIFont.boldSystemFont(ofSize: 20)
        delayTime.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func setupData() {
        //去除火車車種名字後()的特別註記
        let name = data?.trainTypeName
        let newName = name?.components(separatedBy: "(")
        let trainName = newName?[0]
        
        self.trainTypeName.text = trainName
        self.trainNo.text = "\(data?.trainNo ?? "")次"
        self.startTime.text = data?.arrivalTime
        self.endTime.text = data?.departureTime
        
        if trainToday == true {
            if ShareView.shared.timeToTimeStamp(time: ShareView.shared.nowTime()) > ShareView.shared.timeToTimeStamp(time: data?.arrivalTime ?? "") {
                delayTime.text = "已出發"
                delayTime.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                startTime.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                endTime.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            } else {
                if data?.delayTime == 0 {
                    delayTime.text = "準時"
                    delayTime.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                } else {
                    delayTime.text = "晚\(String(data?.delayTime ?? 0))分"
                    delayTime.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                }
            }
        } else {
            delayTime.text = "未發車"
            delayTime.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        
        startTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        endTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        switch trainName {
        case "區間":
            trainTypeName.textColor = #colorLiteral(red: 0.1366842985, green: 0.1123107448, blue: 0.9438511729, alpha: 1)
        case "區間快":
            trainTypeName.textColor = #colorLiteral(red: 0.1366842985, green: 0.1123107448, blue: 0.9438511729, alpha: 1)
        case "莒光":
            trainTypeName.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        case "自強":
            trainTypeName.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        default:
            trainTypeName.textColor = #colorLiteral(red: 1, green: 0.001573321293, blue: 0.0555190295, alpha: 1)
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
