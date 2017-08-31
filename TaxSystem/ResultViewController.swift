//
//  ResultViewController.swift
//  TaxSystem
//
//  Created by Anna on 17.07.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds

class ResultViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var commonSystemLabel: UILabel!
    @IBOutlet weak var simplifiedSystemLabel: UILabel!
    @IBOutlet weak var myBanner: GADBannerView!
    
    var income = Float()
    var outcome = Float()
    var isRetrait = Bool()
    var isVATPayer = Bool()
    
    
    var socialMinimum = Float()
    var minimumSalary = Float()
    
    var ESVRate = Float()
    var militaryRate = Float()
    var NDFLRate = Float()
    var firstGroupRate = Float()
    var secondGroupRate = Float()
    var ENNotVATRate = Float()
    var ENVATRate = Float()
    var maximum = Float()
    
    var taxBase = Float()
    var ESVCommon = Float()
    var ESVSimple = Float()
    var maxESVBase = Float()
    var maxESV = Float()
    var minESV = Float()
    var EN = Float()
    var NDFL = Float()
    var militaryCommon = Float()
    var militarySimple = Float()
    
    var group = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ad banner
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        myBanner.adSize = kGADAdSizeSmartBannerPortrait
        myBanner.adUnitID = advertisementID
        myBanner.rootViewController = self
        myBanner.delegate = self
        myBanner.load(request)
        
        self.navigationController!.navigationBar.topItem!.title = "Назад"
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        maxESVBase = maximum * socialMinimum
        taxBase = income - outcome
        if isRetrait == true {
            ESVCommon = 0
            ESVSimple = 0
        } else {
            ESVCommon = taxBase * ESVRate
            ESVSimple = income * ESVRate
            
            minESV = minimumSalary * ESVRate
            maxESV = maxESVBase * ESVRate
            
            if ESVCommon < minESV{
                ESVCommon = minESV
            }
            if ESVCommon > maxESV {
                ESVCommon = maxESV
            }
            if ESVSimple < minESV {
                ESVSimple = minESV
            }
            if ESVSimple > maxESV {
                ESVSimple = maxESV
            }
        
        }
        NDFL = (taxBase - ESVCommon) * NDFLRate
        if NDFL < 0 {
            NDFL = 0
        }
        
        switch group {
        case 1:
            EN = firstGroupRate * minimumSalary
        case 2:
            EN = secondGroupRate * minimumSalary
        case 3:
            if isVATPayer == true {
                EN = ENVATRate * (income - ESVSimple)
            } else {
                EN = ENNotVATRate * (income - ESVSimple)
            }
        default: break
        }
        if EN < 0 {
            EN = 0
        }
        militaryCommon = (taxBase - ESVCommon) * militaryRate
        if militaryCommon < 0 {
            militaryCommon = 0
        }
        militarySimple = 0
             
        
        commonSystemLabel.text = "Единый социальный взнос \n(ЕСВ): \(ESVCommon) грн.\nНалог на доходы физических лиц\n(НДФЛ): \(NDFL) грн.\nВоенный сбор \(militaryCommon) грн."
        simplifiedSystemLabel.text = "Единый социальный взнос \n(ЕСВ): \(ESVSimple) грн.\nЕдиный налог: \(EN) грн.\nВоенный сбор \(militarySimple) грн."

        
    }

   

}
