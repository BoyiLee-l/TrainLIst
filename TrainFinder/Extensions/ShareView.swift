//
//  ActivityView.swift
//  BusFinder
//
//  Created by user on 2021/3/17.
//

import UIKit

class ShareView {
    static let shared = ShareView()
    var spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityView.style = .large
        } else {
            // Fallback on earlier versions
        }
        return activityView
    }()
    
    func setupActivityView<T: UIView>(view: T) {
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    func startLoading() {
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    func stopLoading() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    /// - Returns: String
    func nowTime() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    //MARK: -根據當前時間轉為時間戳
    func timeToTimeStamp(time: String) -> Double {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="HH:mm"
        let last = dfmatter.date(from: time)
        guard let timeStamp = last?.timeIntervalSince1970 else { return 0.0 }
        return timeStamp
    }
    
    func setBackground(view: UIView){
        let colour1 = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor
        let colour2 = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).cgColor
        let colour3 = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour3,colour2,colour1]
        gradient.locations = [ 0.412,0.822]
        view.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles: [String], actionStyle: [UIAlertAction.Style], action: [((UIAlertAction) -> Void)?]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: action[index])
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func popupActionSheet(title: String, message: String?, actionTitles: [String], actionStyle: [UIAlertAction.Style], action: [((UIAlertAction) -> Void)?]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: action[index])
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
}
