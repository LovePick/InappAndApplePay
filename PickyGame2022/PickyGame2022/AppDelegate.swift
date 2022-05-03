//
//  AppDelegate.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 7/4/2565 BE.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        // Observing Check inapp
//        IAPManager.shared.startObserving()
        return true
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
        // Stop Observing Check inapp
//        IAPManager.shared.stopObserving()
    }
}
