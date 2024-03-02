//
//  AdManager.swift
//  Bible
//
//  Created by Sunfocus Solutions on 29/11/23.
//

import Foundation
import GoogleMobileAds
import StoreKit

class AdManager{
    static let shared = AdManager()
     var startupInterstetial: GADInterstitialAd?

     func loadStartupAd(){
         let request = GADRequest()
         GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                                request: request,
                                completionHandler: { [weak self] ad, error in
             guard let self = self else { return }
             
             if let error = error {
                 print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                 return
             }
             self.startupInterstetial = ad
         }
         )
    }
    
   
    
    func showStartupAd(controller: UIViewController) {
        if let interstitial = startupInterstetial {
            interstitial.present(fromRootViewController: controller)
        } else {
            print("Ad wasn't ready")
        }
    }
    
}
