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
        
        setAdBanner(myBanner: myBanner, vc: self, advertisementID: secondBannerID)
        
        self.navigationController!.navigationBar.topItem!.title = "Назад"
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        taxBase = income - outcome
        ESVCommon = isRetrait ? 0 : (taxBase * ESVRate)
        ESVSimple = isRetrait ? 0 : (income * ESVRate)
        
        if isRetrait == false {
            //check max/min ESV
            maxESVBase = maximum * socialMinimum
            minESV = minimumSalary * ESVRate
            maxESV = maxESVBase * ESVRate
            
            ESVCommon = ESVCommon < minESV ? minESV : ESVCommon
            ESVCommon = ESVCommon > maxESV ? maxESV : ESVCommon
            ESVSimple = ESVSimple < minESV ? minESV : ESVSimple
            ESVSimple = ESVSimple > maxESV ? maxESV : ESVSimple
        }
        
        NDFL = (taxBase - ESVCommon) * NDFLRate
        NDFL = NDFL < 0 ? 0 : NDFL
        
        switch group {
        case 1:
            EN = firstGroupRate * minimumSalary
        case 2:
            EN = secondGroupRate * minimumSalary
        case 3:
            EN = isVATPayer ? (ENVATRate * (income - ESVSimple)) : (ENNotVATRate * (income - ESVSimple))
        default: break
        }
        EN = EN < 0 ? 0 : EN

        militaryCommon = (taxBase - ESVCommon) * militaryRate
        militaryCommon = militaryCommon < 0 ? 0 : militaryCommon
        militarySimple = 0
             
        
        commonSystemLabel.text = "Единый социальный взнос \n(ЕСВ): \(ESVCommon) грн.\nНалог на доходы физических лиц\n(НДФЛ): \(NDFL) грн.\nВоенный сбор \(militaryCommon) грн."
        simplifiedSystemLabel.text = "Единый социальный взнос \n(ЕСВ): \(ESVSimple) грн.\nЕдиный налог: \(EN) грн.\nВоенный сбор \(militarySimple) грн."
    }
}
