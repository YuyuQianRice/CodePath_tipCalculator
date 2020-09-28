//
//  SettingViewController.swift
//  tip
//
//  Created by Yuyu Qian on 9/25/20.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let defaults = UserDefaults.standard
    let pickerData = ["The United States", "China", "Europe", "England"]
    let symbols = ["\u{24}", "\u{A5}", "\u{20AC}", "\u{A3}"]
    
    @IBOutlet weak var isNightModeOn: UISwitch!
    
    @IBOutlet weak var tipRatePreSet: UITextField!
    
    @IBOutlet weak var currencySymbolSelected: UITextField!
    
    @IBOutlet weak var locationPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //the following are delegate functions used for different occasions
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        currencySymbolSelected.text = symbols[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        loadDefault ()
        setBackgroundColor()
    }
    
    
    override func loadView() {
        super.loadView()
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        loadDefault ()
        setBackgroundColor()
    }
    
    @IBAction func saveButtonTap(_ sender: Any) {
        //Access UserDefaults
        
        defaults.set(Int(tipRatePreSet.text ?? "15"), forKey: "tipRatePreSet")
        
        defaults.set(currencySymbolSelected.text ?? "\u{24}", forKey: "currencySymbol")
        
        defaults.set(isNightModeOn.isOn, forKey: "isNightMode")

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
        locationPicker.selectRow(symbols.index(of: currencySymbolSelected.text ?? "\u{24}") ?? 0, inComponent: 0, animated: true)
    }
    
    func setBackgroundColor() {
        self.view.overrideUserInterfaceStyle = defaults.bool(forKey: "isNightMode") ? .dark : .light
    }
}
