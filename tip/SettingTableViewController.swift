//
//  SettingTableViewController.swift
//  tip
//
//  Created by Yuyu Qian on 9/28/20.
//

import UIKit

class SettingTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //return table view controller section number
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    //return table view controller row count for every section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rowCount: Int
        switch section {
            case 0:
                rowCount = 3
            case 1:
                rowCount = 3
            case 2:
                rowCount = 2
            default:
                rowCount = 1
        }
        return rowCount
    }
    
    //return table view controller section titles
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                sectionName = NSLocalizedString("Preset Settings", comment: "Preset Settings")
            case 1:
                sectionName = NSLocalizedString("Exchange Settings", comment: "Exchange Settings")
            case 2:
                sectionName = NSLocalizedString("Split Settings", comment: "Split Settings")
            default:
                sectionName = ""
        }
        return sectionName
    }

    let defaults = UserDefaults.standard
    let pickerData = ["The United States", "China", "Europe", "England"]
    let currencyData = ["USD", "CNY", "EUR", "GBP"]
    let symbols = ["\u{24}", "\u{A5}", "\u{20AC}", "\u{A3}"]
    var fromCurrencyCode = "USD"
    var toCurrencyCode = "USD"
   
    @IBOutlet weak var toCurLabel: UILabel!
    
//    @IBOutlet weak var _to_Label: UILabel!
    
    @IBOutlet weak var exchangeRate: UILabel!
    
    @IBOutlet weak var howManyPpl: UILabel!
    
    @IBOutlet weak var peopleNumText: UITextField!
    
    @IBOutlet weak var tipRatePreSet: UITextField!

    @IBOutlet weak var locationPicker: UIPickerView!
    
    @IBOutlet weak var toCurrencyPicker: UIPickerView!
    
    @IBOutlet weak var isNightModeOn: UISwitch!
    
    @IBOutlet weak var splitMode: UISwitch!
    
    @IBOutlet weak var exchangeMode: UISwitch!
    
    @IBOutlet weak var currencySymbolSelected: UITextField!
    
    @IBOutlet weak var exchangeInfo: UILabel!
    
    @IBAction func exchangeModeToggle(_ sender: Any) {
        toggleExchangeSettingHiden(exchangeMode.isOn)
    }
    
    //toggle the visibility of widgets for currency exchange
    func toggleExchangeSettingHiden(_ on:Bool) {
        if (on) {
            toCurrencyPicker.isHidden = false
            exchangeInfo.isHidden = false
            toCurLabel.isHidden = false
            exchangeRate.isHidden = false
        } else {
            toCurrencyPicker.isHidden = true
            exchangeInfo.isHidden = true
            toCurLabel.isHidden = true
            exchangeRate.isHidden = true
        }
    }
    
    func toggleSplitSettingHidden (_ on:Bool) {
        if(on) {
            howManyPpl.isHidden = false
            peopleNumText.isHidden = false
        } else {
            howManyPpl.isHidden = true
            peopleNumText.isHidden = true
        }
    }
    
    //update the exchange rate currency codes
    func updateExchangeInfo() {
        fromCurrencyCode = currencyData[locationPicker.selectedRow(inComponent: 0)]
        toCurrencyCode = currencyData[toCurrencyPicker.selectedRow(inComponent: 0)]
        exchangeInfo.text = fromCurrencyCode + " to " + toCurrencyCode;
    }
    
    //return number of components of pickers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var numOfComp = 0;
        switch pickerView {
            case locationPicker:
                numOfComp = 1
            case toCurrencyPicker:
                numOfComp = 1
            default:
                numOfComp = 1
        }
        return numOfComp
    }
    
    //the following are delegate functions used for different occasions
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numOfRows = 0;
        switch pickerView {
            case locationPicker:
                numOfRows = pickerData.count
            case toCurrencyPicker:
                numOfRows = currencyData.count
            default:
                numOfRows = 0
        }
        return numOfRows
    }
    
    //return corresponding row data for corresponding component in corresponding picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowData = "";
        switch pickerView {
            case locationPicker:
                rowData = pickerData[row]
            case toCurrencyPicker:
                rowData = currencyData[row]
            default:
                rowData = ""
        }

        return rowData
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        switch pickerView {
            case locationPicker:
                self.currencySymbolSelected.text = symbols[row]
                updateExchangeInfo()
                exchangeRate.text = ""
            case toCurrencyPicker:
                updateExchangeInfo()
                CurrencyExchangeRateGet()
            default: break
                
        }
    }
    
    func viewUpdate() {
        exchangeInfo.text = fromCurrencyCode + " to " + toCurrencyCode;
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        self.toCurrencyPicker.delegate = self
        self.toCurrencyPicker.dataSource = self
        loadDefault()
        setBackgroundColor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUpdate()
    }
    
    override func loadView() {
        super.loadView()
        viewUpdate()
    }
    
    @IBAction func splitModeButtonToggle(_ sender: Any) {
        toggleSplitSettingHidden(splitMode.isOn)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Access UserDefaults
        print("tip rate: " + String((abs(Int(tipRatePreSet.text ?? "15") ?? 15)) % 100))
        defaults.set((abs(Int(tipRatePreSet.text ?? "15") ?? 15)) % 100, forKey: "tipRatePreSet")
        
        defaults.set(currencySymbolSelected.text ?? "\u{24}", forKey: "currencySymbol")
        
        defaults.set(isNightModeOn.isOn, forKey: "isNightMode")

        defaults.set(toCurrencyCode, forKey: "toCurrency")
        
        defaults.set(exchangeRate.text, forKey: "exchangeRate")
        
        defaults.set(exchangeMode.isOn, forKey: "exchangeMode")
        
        defaults.set(splitMode.isOn, forKey: "splitMode")
        
        defaults.set(peopleNumText.text, forKey: "peopleCount")
        
        
        // Force UserDefaults to save.
        defaults.synchronize()
    }
    
//    @IBAction func saveButtonTap(_ sender: UIButton) {
//        sender.saveButtonClick()
//
//        //Access UserDefaults
//        print("tip rate: " + String((abs(Int(tipRatePreSet.text ?? "15") ?? 15)) % 100))
//        defaults.set((abs(Int(tipRatePreSet.text ?? "15") ?? 15)) % 100, forKey: "tipRatePreSet")
//
//        defaults.set(currencySymbolSelected.text ?? "\u{24}", forKey: "currencySymbol")
//
//        defaults.set(isNightModeOn.isOn, forKey: "isNightMode")
//
//        defaults.set(toCurrencyCode, forKey: "toCurrency")
//
//        defaults.set(exchangeRate.text, forKey: "exchangeRate")
//
//        defaults.set(exchangeMode.isOn, forKey: "exchangeMode")
//
//        // Force UserDefaults to save.
//        defaults.synchronize()
//
//        self.loadView()
//    }
    
    @IBAction func nightModeButtonChanged(_ sender: Any) {
        self.view.overrideUserInterfaceStyle = isNightModeOn.isOn ? .dark : .light
    }
    
    func loadDefault() {
        currencySymbolSelected.text = defaults.string(forKey: "currencySymbol")
        tipRatePreSet.text = String(defaults.integer(forKey: "tipRatePreSet"))
        isNightModeOn.isOn = defaults.bool(forKey: "isNightMode")
        locationPicker.selectRow(symbols.firstIndex(of: currencySymbolSelected.text ?? "\u{24}") ?? 0, inComponent: 0, animated: true)
        
        fromCurrencyCode = currencyData[locationPicker.selectedRow(inComponent: 0)]
        toCurrencyCode = defaults.string(forKey: "toCurrency") ?? "USD"
        exchangeRate.text = defaults.string(forKey: "exchangeRate")
                
        toCurrencyPicker.selectRow(currencyData.firstIndex(of: toCurrencyCode ) ?? 0, inComponent: 0, animated: true)
        
        exchangeMode.isOn = defaults.bool(forKey: "exchangeMode")
        
        splitMode.isOn = defaults.bool(forKey: "splitMode")
        
        peopleNumText.text = defaults.string(forKey: "peopleCount")
        
        toggleSplitSettingHidden(splitMode.isOn)
        
        toggleExchangeSettingHiden(exchangeMode.isOn)
    }
    
    
    
    func setBackgroundColor() {
        self.view.overrideUserInterfaceStyle = defaults.bool(forKey: "isNightMode") ? .dark : .light
    }
    
    func CurrencyExchangeRateGet() {
        // Create URL
        
        if (toCurrencyCode == fromCurrencyCode) {
            exchangeRate.text = "1.0000"
            return
        }
        
        let urlString = "https://free.currconv.com/api/v7/convert?q=" + fromCurrencyCode + "_" + toCurrencyCode + "&compact=ultra&apiKey=19f56650ad3b6bbe3aa6"
        let url = URL(string: urlString)
        guard let requestUrl = url else { fatalError() }
        
        print("URL: " + urlString)

        // Create URL Request
        var request = URLRequest(url: requestUrl)

        // Specify HTTP Method to use
        request.httpMethod = "GET"

        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            let keyValue: String = self.fromCurrencyCode + "_" + self.toCurrencyCode
            
             let firstValue =
                try! JSONSerialization.jsonObject(
                    with: data!,
                    options: .mutableContainers
                ) as! [String: Any]
            DispatchQueue.main.async {
                self.exchangeRate.text = "\(firstValue.first!.value)"
            }

        }
        task.resume()
    }
}
