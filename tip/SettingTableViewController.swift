//
//  SettingTableViewController.swift
//  tip
//
//  Created by Yuyu Qian on 9/28/20.
//

import UIKit

class SettingTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rowCount: Int
        switch section {
            case 0:
                rowCount = 3
            case 1:
                rowCount = 5
            default:
                rowCount = 1
        }
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                sectionName = NSLocalizedString("Preset Settings", comment: "Preset Settings")
            case 1:
                sectionName = NSLocalizedString("Exchange Settings", comment: "Exchange Settings")
            default:
                sectionName = ""
        }
        return sectionName
    }

    let defaults = UserDefaults.standard
    let pickerData = ["The United States", "China", "Europe", "England"]
    let currencyData = ["USD", "CNY", "EUR", "GBP"]
    let symbols = ["\u{24}", "\u{A5}", "\u{20AC}", "\u{A3}"]
    var fromCurrencyCode = "None"
    var toCurrencyCode = "None"
   
    @IBOutlet weak var toCurLabel: UILabel!
    
    @IBOutlet weak var _to_Label: UILabel!
    
    @IBOutlet weak var exchangeRate: UILabel!
    
    @IBOutlet weak var fetchRateButton: UIButton!
    
    @IBOutlet weak var isNightModeOn: UISwitch!
    
    @IBOutlet weak var tipRatePreSet: UITextField!

    @IBOutlet weak var locationPicker: UIPickerView!
    
    @IBOutlet weak var toCurrencyPicker: UIPickerView!
    
    @IBOutlet weak var exchangeMode: UISwitch!
    
    @IBOutlet weak var currencySymbolSelected: UITextField!
    
    @IBOutlet weak var exchangeInfo: UILabel!
    
    @IBAction func exchangeModeToggle(_ sender: Any) {
        toggleExchangeSettingHiden(exchangeMode.isOn)
    }
    
    func toggleExchangeSettingHiden(_ on:Bool) {
        if (on) {
            toCurrencyPicker.isHidden = false
            _to_Label.isHidden = false
            toCurLabel.isHidden = false
            exchangeRate.isHidden = false
            fetchRateButton.isHidden = false
        } else {
            toCurrencyPicker.isHidden = true
            _to_Label.isHidden = true
            toCurLabel.isHidden = true
            exchangeRate.isHidden = true
            fetchRateButton.isHidden = true
        }
    }
    
    
    func updateExchangeInfo() {
        fromCurrencyCode = currencyData[locationPicker.selectedRow(inComponent: 0)]
        toCurrencyCode = currencyData[toCurrencyPicker.selectedRow(inComponent: 0)]
        exchangeInfo.text = fromCurrencyCode + " to " + toCurrencyCode;
    }
    
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
            case toCurrencyPicker:
                updateExchangeInfo()
            default: break
                
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeInfo.text = fromCurrencyCode + " to " + toCurrencyCode;
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        self.toCurrencyPicker.delegate = self
        self.toCurrencyPicker.dataSource = self
        loadDefault()
        setBackgroundColor()
    }
    
    
    override func loadView() {
        super.loadView()
        exchangeInfo.text = fromCurrencyCode + " to " + toCurrencyCode;
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        self.toCurrencyPicker.delegate = self
        self.toCurrencyPicker.dataSource = self
        loadDefault()
        setBackgroundColor()
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        sender.saveButtonClick()
        
        //Access UserDefaults
        defaults.set((abs(Int(tipRatePreSet.text ?? "15") ?? 15)) % 100, forKey: "tipRatePreSet")
        
        defaults.set(currencySymbolSelected.text ?? "\u{24}", forKey: "currencySymbol")
        
        defaults.set(isNightModeOn.isOn, forKey: "isNightMode")

        defaults.set(toCurrencyCode, forKey: "toCurrency")
        
        defaults.set(exchangeRate.text, forKey: "exchangeRate")
        
        defaults.set(exchangeMode.isOn, forKey: "exchangeMode")
        
        // Force UserDefaults to save.
        defaults.synchronize()
        
        self.loadView()
        self.parent?.reloadInputViews()
    }
    
    @IBAction func nightModeButtonChanged(_ sender: Any) {
        self.view.overrideUserInterfaceStyle = isNightModeOn.isOn ? .dark : .light
    }
    
    func loadDefault() {
        currencySymbolSelected.text = defaults.string(forKey: "currencySymbol")
        tipRatePreSet.text = String(defaults.integer(forKey: "tipRatePreSet"))
        isNightModeOn.isOn = defaults.bool(forKey: "isNightMode")
        locationPicker.selectRow(symbols.firstIndex(of: currencySymbolSelected.text ?? "\u{24}") ?? 0, inComponent: 0, animated: true)
        
        fromCurrencyCode = currencyData[locationPicker.selectedRow(inComponent: 0)]
        toCurrencyCode = defaults.string(forKey: "toCurrency") ?? "None"
        exchangeRate.text = defaults.string(forKey: "exchangeRate")
        
        if (toCurrencyCode != "None") {
            toCurrencyPicker.selectRow(currencyData.firstIndex(of: toCurrencyCode ) ?? 0, inComponent: 0, animated: true)
        }
        
        exchangeMode.isOn = defaults.bool(forKey: "exchangeMode")
        
        toggleExchangeSettingHiden(exchangeMode.isOn)
    }
    
    func setBackgroundColor() {
        self.view.overrideUserInterfaceStyle = defaults.bool(forKey: "isNightMode") ? .dark : .light
    }
    
    @IBAction func CurrencyExchangeRateGet(_ sender: Any) {
        // Create URL
        
        struct _USD_CNY: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let USD_CNY: Float
        }
        
        struct _USD_EUR: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let USD_EUR: Float
        }
        
        struct _USD_GBP: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let USD_GBP: Float
        }
        
        struct _CNY_USD: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let CNY_USD: Float
        }

        struct _CNY_EUR: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let CNY_EUR: Float
        }
        struct _CNY_GBP: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let CNY_GBP: Float
        }
        struct _EUR_USD: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let EUR_USD: Float
        }
        
        struct _EUR_CNY: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let EUR_CNY: Float
        }
        struct _EUR_GBP: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let EUR_GBP: Float
        }
        struct _GBP_USD: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let GBP_USD: Float
        }
        
        struct _GBP_CNY: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let GBP_CNY: Float
        }
        
        struct _GBP_EUR: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let GBP_EUR: Float
        }
        
        if (toCurrencyCode == fromCurrencyCode) {
            exchangeRate.text = "1.0000"
            return
        }
        
        let urlString = "https://free.currconv.com/api/v7/convert?q=" + fromCurrencyCode + "_" + toCurrencyCode + "&compact=ultra&apiKey=19f56650ad3b6bbe3aa6"
        let url = URL(string: urlString)
        guard let requestUrl = url else { fatalError() }

        // Create URL Request
        var request = URLRequest(url: requestUrl)

        // Specify HTTP Method to use
        request.httpMethod = "GET"

        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
            switch keyValue {
            case "USD_CNY":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    //print("Response data string:\n \(dataString)")
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _USD_CNY = try! JSONDecoder().decode(_USD_CNY.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.USD_CNY)"
                }
            case "USD_EUR":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _USD_EUR = try! JSONDecoder().decode(_USD_EUR.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.USD_EUR)"
                }
            case "USD_GBP":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _USD_GBP = try! JSONDecoder().decode(_USD_GBP.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.USD_GBP)"
                }
            case "CNY_USD":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _CNY_USD = try! JSONDecoder().decode(_CNY_USD.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.CNY_USD)"
                }
            case "CNY_EUR":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _CNY_EUR = try! JSONDecoder().decode(_CNY_EUR.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.CNY_EUR)"
                }
            case "CNY_GBP":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _CNY_GBP = try! JSONDecoder().decode(_CNY_GBP.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.CNY_GBP)"
                }
            case "EUR_USD":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _EUR_USD = try! JSONDecoder().decode(_EUR_USD.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.EUR_USD)"
                }
            case "EUR_CNY":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _EUR_CNY = try! JSONDecoder().decode(_EUR_CNY.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.EUR_CNY)"
                }
            case "EUR_GBP":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _EUR_GBP = try! JSONDecoder().decode(_EUR_GBP.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.EUR_GBP)"
                }
            case "GBP_USD":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _GBP_USD = try! JSONDecoder().decode(_GBP_USD.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.GBP_USD)"
                }
            case "GBP_CNY":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _GBP_CNY = try! JSONDecoder().decode(_GBP_CNY.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.GBP_CNY)"
                }
            case "GBP_EUR":
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let jsonData = dataString.data(using: .utf8)!
                    let rate: _GBP_EUR = try! JSONDecoder().decode(_GBP_EUR.self, from: jsonData)
                    self.exchangeRate.text = "\(rate.GBP_EUR)"
                }
            default:
                print(keyValue)
                self.exchangeRate.text = "1.0000"
            }
            // Convert HTTP Response Data to a simple String
        }
        task.resume()
    }
}
