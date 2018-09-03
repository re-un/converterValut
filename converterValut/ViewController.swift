//
//  ViewController.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 17.08.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    var currences = [dataAlgorithm.currence]()
    var selectedRow = 0
    var isAllCurrencesDisplayed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        curPicker.delegate = self
        curPicker.dataSource = self
        firstTextField.delegate = self
        secondTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currences = data.lessCurrneces
        curPicker.reloadAllComponents()
        secondLabel.text = data.lessCurrneces.first?.Cur_Name
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {self.layoutBottom.constant = 235})
    }
    @IBOutlet weak var curPicker: UIPickerView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!{
        didSet{
            firstTextField.clearButtonMode = .always
        }
    }
    @IBOutlet weak var secondTextField: UITextField!{
        didSet{
            secondTextField.clearButtonMode = .always
        }
    }
    @IBOutlet weak var layoutBottom: NSLayoutConstraint!
    @IBOutlet weak var generalView: UIView!
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        isAllCurrencesDisplayed = !isAllCurrencesDisplayed
        if isAllCurrencesDisplayed {
            currences = data.allCurrences
            sender.setTitle("Less", for: .normal)
        }else{
            currences = data.lessCurrneces
            sender.setTitle("More", for: .normal)
        }
        curPicker.reloadAllComponents()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.keyboardType = .decimalPad
        return true
    }
    
    var currentTextField:UITextField?{
        if firstTextField.isEditing{
            return firstTextField
        }
        if secondTextField.isEditing{
            return secondTextField
        }
        return nil
    }
    
    func textToDouble(text:String, textField:UITextField)->Double?{
        if text.isEmpty{
            return nil
        }
        var newString = text
        var count = false
        for index in newString.indices{
            if newString[index] == ","||newString[index] == "."{
                if !count{
                    count = true
                    newString = text.replacingCharacters(in: index...index, with: ".")
                }else{
                    newString.remove(at: index)
                }
            }
        }
        textField.text = newString
        return Double(newString)
    }
    
    func brain(_ textField:UITextField){
        var firstNumber:Double?
        var secondNumber:Double?
        if let fristDouble = firstTextField.text{
            firstNumber = textToDouble(text: fristDouble,textField: firstTextField)
            
        }
        if let secondDouble = secondTextField.text{
            secondNumber = textToDouble(text: secondDouble,textField: secondTextField)
        }
        if textField == secondTextField, secondNumber != nil, data.allCurrences.count > 0{
            firstTextField.text = String(appLogic(count: secondNumber!, currency: currences[selectedRow].Cur_OfficialRate, scale: currences[selectedRow].Cur_Scale))
        }
        if textField == firstTextField, firstNumber != nil, data.allCurrences.count > 0{
            secondTextField.text = String(appLogic(count: firstNumber!, currency: 1/currences[selectedRow].Cur_OfficialRate, scale: currences[selectedRow].Cur_Scale))
        }
    }
    
    func appLogic(count: Double, currency:Double, scale:Int)->Double{
        return count*currency*Double(scale)
    }
    
    @IBAction func editChanched(_ sender: UITextField) {
        brain(sender)
    }
    
    @IBAction func secondEditChanched(_ sender: UITextField) {
        brain(sender)
    }
    
    
    //////
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currences.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currences[row].Cur_Abbreviation
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        secondLabel.text = currences[row].Cur_Name
        selectedRow = row
        brain(currentTextField!)
    }
    
    ///
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        generalView.endEditing(true)
        layoutBottom.constant = 0
    }
}
