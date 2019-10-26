//
//  ViewController.swift
//  Australian Income Tax Calculator
//
//  Created by Peter Hallows on 1/9/19.
//  Copyright © 2019 Peter Hallows. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var medicareSurchargeApplicable: Bool!
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if (sender.isOn == true) {
            medicareSurchargeApplicable = true
        } else {
            medicareSurchargeApplicable = false
        }
    }
    
    // The 'How is this calculated' popup.
    
    @IBOutlet var popup: UIView!
    
    @IBAction func calculatedbutton(_ sender: Any) {
        self.view.addSubview(popup)
        popup.center = self.view.center
    }
    
    @IBAction func backtocalculator(_ sender: Any) {
        self.popup.removeFromSuperview()
    }
    
    @IBOutlet weak var income: UITextField!
    
    @IBOutlet weak var takeHomePay: UITextView!
    
    @IBOutlet weak var incomeTaxPayable: UILabel!
    
    @IBOutlet weak var yellowBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        income.delegate = self
        
        popup.layer.cornerRadius = 10;
        popup.layer.masksToBounds = true;
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        
        income.resignFirstResponder()
        
        if let useableNumber = Float(income.text!) {
            
            // Calculating your after-tax income for the first tax band
            var firstBandTaxPayable: Float
            if useableNumber >= 0 && useableNumber <= 18200 {
                firstBandTaxPayable = 0
            } else {
                firstBandTaxPayable = 0
            }
            
            // Calculating your after-tax income for the second tax band
            var secondBandTaxPayable: Float
            if useableNumber >= 18200 && useableNumber <= 37000 {
                secondBandTaxPayable = (useableNumber - 18200) * 0.19
            } else if useableNumber > 37000 {
                secondBandTaxPayable = 3572
            } else {
                secondBandTaxPayable = 0
            }
            
            // Calculating your after-tax income for the third tax band
            var thirdBandTaxPayable: Float
            if useableNumber >= 37001 && useableNumber <= 90000 {
                thirdBandTaxPayable = (useableNumber - 37001) * 0.325
            } else if useableNumber > 90000 {
                thirdBandTaxPayable = 17225
            } else {
                thirdBandTaxPayable = 0
            }
            
            // Calculating your after-tax income for the fourth tax band
            var fourthBandTaxPayable: Float
            if useableNumber >= 90001 && useableNumber <= 180000 {
                fourthBandTaxPayable = (useableNumber - 90000) * 0.37
            } else if useableNumber > 180000 {
                fourthBandTaxPayable = 33300
            } else {
                fourthBandTaxPayable = 0
            }
            
            // Calulating your after-tax income for the fifth tax band
            var fifthBandTaxPayable: Float
            if useableNumber > 180000 {
                fifthBandTaxPayable = (useableNumber - 180000) * 0.45
            } else {
                fifthBandTaxPayable = 0
            }
            
            // Calculating medicare levy
            var medicareLevy: Float
            if useableNumber > 26668 {
                medicareLevy = useableNumber * 0.02
            } else {
                medicareLevy = 0
            }
            
            // Calculating medicare levy surcharge
            var medicareLevySurchargePayable: Float
            
            if medicareSurchargeApplicable == true && useableNumber <= 90000 {
                medicareLevySurchargePayable = 0
            } else if medicareSurchargeApplicable == true && useableNumber >= 90001 && useableNumber <= 105000 {
                medicareLevySurchargePayable = useableNumber * 0.01
            } else if medicareSurchargeApplicable == true && useableNumber >= 105001 && useableNumber <= 140000 {
                medicareLevySurchargePayable = useableNumber * 0.0125
            } else if medicareSurchargeApplicable == true && useableNumber >= 14001 {
                medicareLevySurchargePayable = useableNumber * 0.015
            } else {
                medicareLevySurchargePayable = 0
            }
            
            // Adding up the tax payables
            let taxPayable = [firstBandTaxPayable, secondBandTaxPayable, thirdBandTaxPayable, fourthBandTaxPayable, fifthBandTaxPayable, medicareLevy, medicareLevySurchargePayable]
            var totalTax = taxPayable.reduce(0, +)
            
            // Calculating the after-tax income
            var afterTaxIncome = (useableNumber - totalTax)
            afterTaxIncome.round()
            totalTax.round()
            
            // Formatting the final figure into a readable $ figure
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            let finalFigure = numberFormatter.string(from: NSNumber(value:afterTaxIncome))
            
            let finalTaxFigure = numberFormatter.string(from: NSNumber(value:totalTax))
            
            // Displaying the final figure to the user
            takeHomePay.text = "$\(finalFigure!)"
            incomeTaxPayable.text = "$\(finalTaxFigure!)"
        }
        
        if self.income.text!.isEmpty {
            takeHomePay.text = "$0"
            incomeTaxPayable.text = "$0"
        }
        
    }
    
    // Closing the numberpad when you tap outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        income.resignFirstResponder()
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

////      Rounding corners of a label
//        xyz.layer.masksToBounds = true;
//        xyz.layer.cornerRadius = 5;


