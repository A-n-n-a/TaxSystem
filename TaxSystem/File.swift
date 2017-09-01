//
//  File.swift
//  TaxSystem
//
//  Created by Anna on 9/1/17.
//  Copyright © 2017 Anna. All rights reserved.
//

import Foundation
import GoogleMobileAds

func setAdBanner(myBanner: GADBannerView!, vc: UIViewController, advertisementID: String) {
    let request = GADRequest()
    request.testDevices = [kGADSimulatorID]
    myBanner.adUnitID = advertisementID
    myBanner.rootViewController = vc
    myBanner.delegate = vc as! GADBannerViewDelegate
    myBanner.load(request)
}
