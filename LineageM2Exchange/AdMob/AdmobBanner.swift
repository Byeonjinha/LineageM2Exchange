//
//  AdmobBanner.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/30.
//

import GoogleMobileAds
import SwiftUI

struct
GADBannerViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
    let view = GADBannerView(adSize: GADAdSizeBanner)
    let viewController = UIViewController()
    view.adUnitID = "ca-app-pub-3363690747307113/4382956386"
    view.rootViewController = viewController
    viewController.view.addSubview(view)
    viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
    view.load(GADRequest())
    return viewController
    }
 
    
    
    
func updateUIViewController(
_ uiViewController: UIViewController,
context: Context) {
    
    }
}
