//
//  ViewController.swift
//  tip
//
//  Created by Yuyu Qian on 9/24/20.
//

import UIKit


//add functionality/field for Date class to achieve timeout data clearing
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

//use for different formatting for different currency
//CNY will use seperator every four digits !!!
extension Formatter {
    static let rmb: NumberFormatter = {
        let formatter = NumberFormatter()
        // set the numberStyle to .CurrencyStyle
        formatter.numberStyle = .currency
        // set the desired negative and positive formats grouping, and currency symbol position
        formatter.positiveFormat = "#,###0.00 ¤"
        formatter.negativeFormat = "-#,###0.00 ¤"
        // set your custom currency symbol
        formatter.currencySymbol = ""
        return formatter
    }()
    
    static let other: NumberFormatter = {
        let formatter = NumberFormatter()
        // set the numberStyle to .CurrencyStyle
        formatter.numberStyle = .currency
        // set the desired negative and positive formats grouping, and currency symbol position
        formatter.positiveFormat = "#,##0.00 ¤"
        formatter.negativeFormat = "-#,##0.00 ¤"
        // set your custom currency symbol
        formatter.currencySymbol = ""
        return formatter
    }()
}

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
    
    func initViewsOrAppearance () {
        defaults.synchronize()
        let doubleTapGr = UITapGestureRecognizer(target: self, action: #selector(doubleTapFunc(_:)))
        doubleTapGr.numberOfTapsRequired = 2
        doubleTapGr.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(doubleTapGr)
        self.view.isUserInteractionEnabled = true

        currencySymbol = defaults.string(forKey: "currencySymbol") ?? "\u{24}"
        
        if (defaults.integer(forKey: "tipRatePreSet") != 0) {
            usingSlider = true
            tipRatePercentile.text = String(format: "%d%%", Int(defaults.integer(forKey: "tipRatePreSet")))
        }
        
        self.view.overrideUserInterfaceStyle = defaults.bool(forKey: "isNightMode") ? .dark : .light
        
        toCurrencyCode = defaults.string(forKey: "toCurrency") ?? "USD"
        exchangeRate = defaults.double(forKey: "exchangeRate")
        exchangeMode = defaults.bool(forKey: "exchangeMode")
        toggleExchangeInfo(exchangeMode)
        billAmount.becomeFirstResponder()
        billAmount.text = String(defaults.string(forKey: "billAmount") ?? "")
        calculateTip(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("view did appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("view will disappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("view did disappear")
    }

    //called when return from setting view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("view will appear")
        initViewsOrAppearance()
    }
    
    //called when first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewsOrAppearance()
    }
    
    //double tap to clear the bill amount
    @objc func doubleTapFunc(_ sender: Any){
        billAmount.text = ""//String(format: "%.2f", 0)
        calculateTip(self)
    }
    
    
//    @IBAction func doubleTapped(_ sender: Any){
//        billAmount.text = String(format: "%.2f", 0)
//    }

    //used to end bill amount text editing
    @IBAction func onTap(_ sender: Any) {
//        view.endEditing(true)
    }
    
    //calculate the tip using corresponding tip rate
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
        rateLabel.text = "* " + String(format: "%.4f", exchangeRate) + " To"
        if (currencySymbol == "\u{A5}") { //use chinese way of seperating
            tipLabel.text = currencySymbol + String(Formatter.rmb.string(for: tip) ?? "")
            totalLabel.text =  currencySymbol + String(Formatter.rmb.string(for: (tip + bill)) ?? "")
        } else {
            tipLabel.text = currencySymbol + String(Formatter.other.string(for: tip) ?? "")
            totalLabel.text =  currencySymbol + String(Formatter.other.string(for: (tip + bill)) ?? "")
        }
        if (symbols[currencyCode.firstIndex(of: toCurrencyCode) ?? 0] == "\u{A5}") {
            newTotal.text =  symbols[currencyCode.firstIndex(of: toCurrencyCode) ?? 0] + String(Formatter.rmb.string(for: (exchangeRate * (tip + bill))) ?? "")
        } else {
            newTotal.text =  symbols[currencyCode.firstIndex(of: toCurrencyCode) ?? 0] + String(Formatter.other.string(for: (exchangeRate * (tip + bill))) ?? "")
        }
        
        //store current time and this billAmount into defaults
        defaults.set(Date().millisecondsSince1970, forKey: "millisecondsSince1970")
        defaults.set(billAmount.text, forKey: "billAmount")
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

