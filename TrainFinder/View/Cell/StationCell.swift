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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setText()
    }
    
    func setText() {
        startTime.font = UIFont.boldSystemFont(ofSize: 20)
        endTime.font = UIFont.boldSystemFont(ofSize: 20)
        startTime.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        endTime.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    func setContent() {
        self.backgroundColor = .clear
        trainTypeName.text = data?.trainTypeName
        trainNo.text = data?.trainNo
        startTime.text = data?.arrivalTime
        endTime.text = data?.departureTime
        
        if ShareView.shared.timeToTimeStamp(time: ShareView.shared.nowTime()) > ShareView.shared.timeToTimeStamp(time: data?.arrivalTime ?? "") {
            delayTime.text = "已過站"
            delayTime.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            if data?.delayTime == 0 {
                delayTime.text = "準點"
                delayTime.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            } else {
                delayTime.text = "晚\(String(data?.delayTime ?? 0))分"
                delayTime.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
