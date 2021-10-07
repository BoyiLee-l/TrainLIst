//
//  TabBarVc.swift
//  TrainFinder
//
//  Created by user on 2021/9/16.
//

import UIKit

class TabBarVc: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.tag == 0 {
            print(viewController.tabBarItem.tag)
            
            return true
        } else {
            print(viewController.tabBarItem.tag)
            
            return true
        }
    }

}
