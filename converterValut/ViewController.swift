//
//  ViewController.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 17.08.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var currences = [dataAlgorithm.currence]()
    var selectedRow = 0
    var roundNumber = 2
    var firstTextFieldNumber = 0.0 
    var secondTextFieldNumber = 0.0
    var isAllCurrencesDisplayed = false
    var keyboardHeight:CGFloat = 0
    
    var updateDate = Date(){
        didSet{
            if Calendar.current.compare(updateDate, to: today, toGranularity: .day) == .orderedSame{
                updateLabel.text = "today"
            }else if Calendar.current.compare(updateDate, to: yesterday, toGranularity: .day) == .orderedSame{
                updateLabel.text = "yesterday"
            }else {
                updateLabel.text = data.dateToString(date: updateDate, dateFormat: "dd.MM.yyyy")
            }
        }
    }
    
    var today = Date()
    var yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curPicker.delegate = self
        curPicker.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currences = data.lessCurrneces
        curPicker.reloadAllComponents()
        secondLabel.text = data.lessCurrneces.first?.Cur_Name
        curPicker.selectRow(1, inComponent: 1, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(getKeyboardHeight(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        updateDate = (data.allCurrences.first?.Date)!
        firstTextField.text = data.currentNacBankValues[0]
        secondTextField.text = data.currentNacBankValues[1]
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {self.layoutBottom.constant = self.keyboardHeight}) 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var curPicker: UIPickerView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
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
    
    @objc func getKeyboardHeight(notification:Notification){
        if let keyboardFrame: NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height + 20
        }
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
        var secondNumber:Double?
        firstNumber = converter.textToDouble(textField: firstTextField)
        secondNumber = converter.textToDouble(textField: secondTextField)
        switch (textField) {
        case secondTextField:
            if (secondNumber == nil || data.allCurrences.count == 0) {
                firstTextField.text = ""
                break
            }
            firstTextField.text = String((1/converter.appLogic(count: 1/secondNumber!, currency: currences[selectedRow].Cur_OfficialRate, scale: currences[selectedRow].Cur_Scale, round: nil)).rounded(toPlaces: roundNumber))
        case firstTextField:
            if (firstNumber == nil || data.allCurrences.count == 0) {
                secondTextField.text = ""
                break
            }
            secondTextField.text = String(converter.appLogic(count: firstNumber!, currency: currences[selectedRow].Cur_OfficialRate, scale: currences[selectedRow].Cur_Scale, round: roundNumber))
        default:
            break
        }
        data.currentNacBankValues = [firstTextField.text, secondTextField.text]
    }
    
    @IBAction func firstEdit(_ sender: UITextField) {
        brain(sender)
    }
    
    @IBAction func secondEdit(_ sender: UITextField) {
        brain(sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let graphVC = segue.destination as? GraphicViewController
        graphVC?.curAbbreviation = currences[selectedRow].Cur_Abbreviation
    }
}

extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? currences.count : data.roundCount.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? currences[row].Cur_Abbreviation : String(data.roundCount[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            secondLabel.text = currences[row].Cur_Name
            selectedRow = row
        }
        if component == 1{
            roundNumber = data.roundCount[row]
        }
        brain(currentTextField!)
    }
}
