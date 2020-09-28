//
//  ViewController.swift
//  tip
//
//  Created by Yuyu Qian on 9/24/20.
//

import UIKit

class ViewController: UIViewController {
    var usingSlider: Bool = false
    let defaults = UserDefaults.standard
    var currencySymbol: String = "\u{24}"
    let tipPercentages = [0.15, 0.18, 0.2]
    let currencyCode = ["USD", "CNY", "EUR", "GBP"]
    let symbols = ["\u{24}", "\u{A5}", "\u{20AC}", "\u{A3}"]
    
    var toCurrencyCode = "None"
    var exchangeRate = 1.0000
    var exchangeMode = false
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var newTotal: UILabel!
    
    @IBOutlet weak var tipRate: UISegmentedControl!
    
    @IBOutlet weak var tipRatePercentile: UILabel!
    
    @IBOutlet weak var rateSlider: UISlider!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.synchronize()
        let doubleTapGr = UITapGestureRecognizer(target: self, action: #selector(doubleTapFunc(_:)))
        doubleTapGr.numberOfTapsRequired = 2
        doubleTapGr.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(doubleTapGr)
        self.view.isUserInteractionEnabled = true

        currencySymbol = defaults.string(forKey: "currencySymbol") ?? "\u{24}"
        
        if (defaults.integer(forKey: "tipRatePreSet") != 15) {
            usingSlider = true
            tipRatePercentile.text = String(format: "%d%%", Int(defaults.integer(forKey: "tipRatePreSet")))
            rateSlider.setValue(Float(defaults.integer(forKey: "tipRatePreSet")), animated: true)
        }
        
//        self.view.backgroundColor = defaults.bool(forKey: "isNightMode") ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.view.overrideUserInterfaceStyle = defaults.bool(forKey: "isNightMode") ? .dark : .light
        
        toCurrencyCode = defaults.string(forKey: "toCurrency") ?? "USD"
        exchangeRate = defaults.double(forKey: "exchangeRate")
        exchangeMode = defaults.bool(forKey: "exchangeMode")
        toggleExchangeInfo(exchangeMode)
        calculateTip(self)
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Not working?
        defaults.synchronize()
        let doubleTapGr = UITapGestureRecognizer(target: self, action: #selector(doubleTapFunc(_:)))
        doubleTapGr.numberOfTapsRequired = 2
        doubleTapGr.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(doubleTapGr)
        self.view.isUserInteractionEnabled = true
            
        currencySymbol = defaults.string(forKey: "currencySymbol") ?? "\u{24}"
        
        if (defaults.integer(forKey: "tipRatePreSet") != 15) {
            usingSlider = true
            tipRatePercentile.text = String(format: "%d%%", Int(defaults.integer(forKey: "tipRatePreSet")))
        }
        
        self.view.overrideUserInterfaceStyle = defaults.bool(forKey: "isNightMode") ? .dark : .light
        
        toCurrencyCode = defaults.string(forKey: "toCurrency") ?? "USD"
        exchangeRate = defaults.double(forKey: "exchangeRate")
        exchangeMode = defaults.bool(forKey: "exchangeMode")
        toggleExchangeInfo(exchangeMode)
        calculateTip(self)
    }
    
    @objc func doubleTapFunc(_ sender: Any){
        billAmount.text = String(format: "%.2f", 0)
        calculateTip(self)
    }
    
//    @IBAction func doubleTapped(_ sender: Any){
//        billAmount.text = String(format: "%.2f", 0)
//    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        // Get the bill amount
        let bill = Double(billAmount.text!) ?? 0
        //?? means assign with 0 if no value
        
        // Calculate the tip and total

        var tip:Double = 0.0
        if (!usingSlider) {
            tip = bill * tipPercentages[tipRate.selectedSegmentIndex]
        } else {
            tip = bill * (Double(rateSlider.value) / 100.0)
        }
        
        // Update tip and total amount
        tipLabel.text = String(format: currencySymbol + "%.2f", tip)
        totalLabel.text = String(format: currencySymbol + "%.2f", tip + bill)
        
        rateLabel.text = "X " + String(format: "%.4f", exchangeRate) + " To"
        newTotal.text =  String(format: symbols[currencyCode.index(of: toCurrencyCode) ?? 0]  + "%.2f", exchangeRate * (tip + bill))
    }
    
    func toggleExchangeInfo (_ exchangeMode:Bool) {
        if (exchangeMode) {
            rateLabel.isHidden = false
            newTotal.isHidden = false
        } else {
            rateLabel.isHidden = true
            newTotal.isHidden = true
        }
    }
    
    @IBAction func rateFiner(_ sender: Any) {
        tipRatePercentile.text = String(format: "%d%%", Int(rateSlider.value))
        usingSlider = true
        calculateTip(sender)
    }
    
    @IBAction func rateCorse(_ sender: Any) {
        tipRatePercentile.text = String(format: "%d%%", Int(tipPercentages[tipRate.selectedSegmentIndex]*100)
        )
        rateSlider.setValue(Float(tipPercentages[tipRate.selectedSegmentIndex]*100), animated: true)
        usingSlider = false
        calculateTip(sender)
    }
    
}

