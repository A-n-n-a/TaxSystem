//
//  ViewController.swift
//  TaxSystem
//
//  Created by Anna on 17.07.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds

let advertisementID = "ca-app-pub-4375494746414239/9066271549"
let secondBannerID = "ca-app-pub-4375494746414239/1494158424"

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GADBannerViewDelegate {
    
    @IBOutlet weak var myBanner: GADBannerView!

    @IBOutlet weak var profitTextField: UITextField!
    @IBOutlet weak var outcomeTextField: UITextField!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkVAT: UIButton!
    
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
    
    let groups = ["1 группа", "2 группа", "3 группа"]
    
    var income = Float()
    var outcome = Float()
    var isRetrait = Bool()
    var isVATPayer = Bool()
    var group = Int()
    
    var emptyCheckBox = UIImage(named: "images")
    var checkBox = UIImage(named: "checked-checkbox-xxl")
    var isPicked = Bool()
    var isVATPicked = Bool()
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAdBanner(myBanner: myBanner, vc: self, advertisementID: advertisementID)
        
        profitTextField.delegate = self
        outcomeTextField.delegate = self
        
        ref = Database.database().reference()
        
        self.ref?.child("socialMinimum").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.socialMinimum = value
                }
            }
        })
        self.ref?.child("minimumSalary").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.minimumSalary = value
                }
            }
        })
        self.ref?.child("ESVRate").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.ESVRate = value
                }
            }
        })
        self.ref?.child("militaryRate").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.militaryRate = value
                }
            }
        })
        self.ref?.child("NDFLRate").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.NDFLRate = value
                }
            }
        })
        self.ref?.child("firstGroupRate").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.firstGroupRate = value
                }
            }
            
        })
        self.ref?.child("secondGroupRate").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.secondGroupRate = value
                }
            }
        })
        self.ref?.child("ENNotVATRate").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.ENNotVATRate = value
                }
            }
        })
        self.ref?.child("ENVATRate").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.ENVATRate = value
                }
            }
        })
        
        self.ref?.child("maximum").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Float {
                DispatchQueue.main.async() {
                    self.maximum = value
                }
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            group = 1
        case 1:
            group = 2
        case 2:
            group = 3
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: groups[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupPicker.selectRow(1, inComponent: 0, animated: true)
        group = 2
    }
    
    @IBAction func calculation(_ sender: UIButton) {
        
        if profitTextField.text != "" && Float(profitTextField.text!) != nil {
            income = Float(profitTextField.text!)!
        }
        if outcomeTextField.text != "" && Float(outcomeTextField.text!) != nil {
            outcome = Float(outcomeTextField.text!)!
        }
        performSegue(withIdentifier: "Segue", sender: self)
    }

    @IBAction func checkBoxButton(_ sender: UIButton) {
        if isPicked {
            checkButton.setImage(emptyCheckBox, for: .normal)
            isRetrait = true
            isPicked = false
        } else {
            checkButton.setImage(checkBox, for: .normal)
            isRetrait = false
            isPicked = true
        }
    }
    
    @IBAction func checkVATStatus(_ sender: Any) {
        if isVATPicked {
            checkVAT.setImage(checkBox, for: .normal)
            isVATPayer = true
            isVATPicked = false
        } else {
            checkVAT.setImage(emptyCheckBox, for: .normal)
            isVATPayer = false
            isVATPicked = true
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController = segue.destination as! ResultViewController
     
        destViewController.income = self.income
        destViewController.outcome = self.outcome
        destViewController.isRetrait = self.isRetrait
        destViewController.isVATPayer = self.isVATPayer
        destViewController.group = self.group
        destViewController.socialMinimum = self.socialMinimum
        destViewController.minimumSalary = self.minimumSalary
        destViewController.ESVRate = self.ESVRate
        destViewController.NDFLRate = self.NDFLRate
        destViewController.militaryRate = self.militaryRate
        destViewController.firstGroupRate = self.firstGroupRate
        destViewController.secondGroupRate = self.secondGroupRate
        destViewController.ENNotVATRate = self.ENNotVATRate
        destViewController.ENVATRate = self.ENVATRate
        destViewController.maximum = self.maximum
        
        print("SOCIAL: \(self.socialMinimum)")
        print("SALARY: \(self.minimumSalary)")

    }

    //key board will dissmiss while touching screeng anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

