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
    var data: StopTime?
    
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
        stationNameLabel.text = data?.stationName?.zhTw
        arrivalTimeLabel.text = data?.arrivalTime
        departureTimeLabel.text = data?.departureTime
        //print(time, doubleArrival, doubleDepartue)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
