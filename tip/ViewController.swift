//
//  ViewController.swift
//  tip
//
//  Created by Yuyu Qian on 9/24/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var tipRate: UISegmentedControl!
    
    @IBOutlet weak var tipRatePercentile: UILabel!
    
    @IBOutlet weak var rateSlider: UISlider!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Not working?
        
        let doubleTapGr = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapGr.numberOfTapsRequired = 2
        doubleTapGr.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(doubleTapGr)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func doubleTap(_ sender: Any){
        print("Double Tap Fired Here")
        billAmount.text = String(format: "%.2f", 0)
    }
    
    @IBAction func doubleTapped(_ sender: Any){
        print("Double Tap Fired")
        billAmount.text = String(format: "%.2f", 0)
    }

    @IBAction func onTap(_ sender: Any) {
        print("One Tap Fired Here")
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        // Get the bill amount
        let bill = Double(billAmount.text!) ?? 0//"!" means it's optional
        // Calculate the tip and total
        let tipPercentages = [0.15, 0.18, 0.2]
        let tip = bill * tipPercentages[tipRate.selectedSegmentIndex]
        
        // Update tip and total amount
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", tip + bill)
    }
    
    @IBAction func rateFiner(_ sender: Any) {
        tipRatePercentile.text = String(format: "%d%%", Int(rateSlider.value))
    }
    
}

