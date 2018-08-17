//
//  ViewController.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 17.08.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    var data = dataAlgorithm()
    override func viewDidLoad() {
        super.viewDidLoad()
        secondLabel.text = data.allCurrences.first?.Cur_Name
        curPicker.delegate = self
        curPicker.dataSource = self
        firstTextField.delegate = self
        secondTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.getAllCurrences()
        curPicker.reloadAllComponents()
        
        super.viewWillAppear(animated)
    }
    @IBOutlet weak var curPicker: UIPickerView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBAction func changeButton(_ sender: UIButton) {
    }
    @IBOutlet weak var layoutBottom: NSLayoutConstraint!
    var currentTextField:UITextField?
    @IBOutlet weak var generalView: UIView!
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //self.layoutBottom.constant = 280
        UIView.animate(withDuration: 0.3, animations: {self.generalView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -255)})
        currentTextField = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentTextField == textField{
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.layoutBottom.constant = 20
        UIView.animate(withDuration: 0.3, animations: {self.generalView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)})
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.allCurrences.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data.allCurrences[row].Cur_Abbreviation
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        secondLabel.text = data.allCurrences[row].Cur_Name
    }
}

