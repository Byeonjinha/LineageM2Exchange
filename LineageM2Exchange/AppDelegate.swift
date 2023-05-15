//
//  AppDelegate.swift
//  LineageM2Exchange
//
//  Created by Byeon jinha on 2023/01/12.
//

import UIKit
import AppTrackingTransparency
import AdSupport
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestPermission()
            return true
    }
     
     func requestPermission() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             if #available(iOS 14, *) {
                 ATTrackingManager.requestTrackingAuthorization { status in
                     switch status {
                     case .authorized:
                         print(ASIdentifierManager.shared().advertisingIdentifier)
                         
                     case .denied:
                         print("Denied")
                         
                     case .notDetermined:
                         // Tracking authorization dialog has not been shown
                         print("Not determined")
                         
                     case .restricted:
                         print("Restricted")
                         
                     @unknown default: print("Unknown")
                     }
                 }
             } else {
                 // Fallback on earlier versions
             }
         }
     }
}
