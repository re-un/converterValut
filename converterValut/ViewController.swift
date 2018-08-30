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
    var selectedRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        curPicker.delegate = self
        curPicker.dataSource = self
        firstTextField.delegate = self
        secondTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.getAllCurrences()
        curPicker.reloadAllComponents()
        secondLabel.text = data.allCurrences.first?.Cur_Name
        super.viewWillAppear(animated)
    }
    @IBOutlet weak var curPicker: UIPickerView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!{
        didSet{
            firstTextField.becomeFirstResponder()
            if firstTextField != nil,secondTextField != nil {brain(firstTextField)}
        }
    }
    @IBOutlet weak var secondTextField: UITextField!{
        didSet{
            if firstTextField != nil, secondTextField != nil{
                brain(secondTextField)
                
            }
        }
    }
    @IBAction func changeButton(_ sender: UIButton) {
    }
    @IBOutlet weak var layoutBottom: NSLayoutConstraint!
    @IBOutlet weak var generalView: UIView!
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        brain(textField)
        textField.keyboardType = .decimalPad
        UIView.animate(withDuration: 0.2, animations: {self.generalView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -215)})
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
    
    func brain(_ textField:UITextField){
        var firstNumber:Double?
        if let fristDouble = firstTextField.text{
            firstNumber = Double(fristDouble)
        }
        var secondNumber:Double?
        if let secondDouble = secondTextField.text{
            secondNumber = Double(secondDouble)
        }
        if textField == secondTextField, secondNumber != nil, data.allCurrences.count > 0{
            firstTextField.text = String(appLogic(count: secondNumber!, currency: data.allCurrences[selectedRow].Cur_OfficialRate, scale: data.allCurrences[selectedRow].Cur_Scale))
        }
        if textField == firstTextField, firstNumber != nil, data.allCurrences.count > 0{
            secondTextField.text = String(appLogic(count: firstNumber!, currency: 1/data.allCurrences[selectedRow].Cur_OfficialRate, scale: data.allCurrences[selectedRow].Cur_Scale))
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        brain(textField)
    }
    
    func appLogic(count: Double, currency:Double, scale:Int)->Double{
        return count*currency*Double(scale)
    }
    
    @IBAction func editChanched(_ sender: UITextField) {
        print(123)
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
        return data.allCurrences.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data.allCurrences[row].Cur_Abbreviation
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        secondLabel.text = data.allCurrences[row].Cur_Name
        selectedRow = row
        brain(currentTextField!)
    }
}
