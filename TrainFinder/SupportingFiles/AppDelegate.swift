//
//  AppDelegate.swift
//  BusFinder
//
//  Created by user on 2021/3/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let navigationBarColor =  UINavigationBar.appearance()
//        navigationBarColor.barTintColor = #colorLiteral(red: 0.976000011, green: 0.8496015072, blue: 0.5488778949, alpha: 1)
//        navigationBarColor.tintColor = .black
//        navigationBarColor.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let tabBarColor =  UITabBar.appearance()
        
        tabBarColor.tintColor = .black
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

