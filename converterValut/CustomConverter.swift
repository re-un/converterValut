//
//  CustomConverter.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 03.09.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import UIKit

class CustomConverter: UIViewController {

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var currenceTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBAction func firstChanched(_ sender: UITextField) {
        brain(sender)
    }
    @IBAction func currenceChanched(_ sender: UITextField) {
        brain(sender)
    }
    @IBAction func secondChanched(_ sender: UITextField) {
        brain(sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currenceTextField.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {self.bottom.constant = self.keyboardHeight})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstTextField.text = data.currentCustomConverter[0]
        currenceTextField.text = data.currentCustomConverter[1]
        secondTextField.text = data.currentCustomConverter[2]
        NotificationCenter.default.addObserver(self, selector: #selector(getKeyboardHeight(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          AppUtility.lockOrientation(.all)
    }
    
    var keyboardHeight:CGFloat = 0
    var customCurrence = 0.0
    var conv = converter()
    
    func brain(_ textField:UITextField){
        var firstNumber:Double?
        var secondNumber:Double?
        var currence:Double?
        if let fristDouble = firstTextField.text{
            firstNumber = conv.textToDouble(text: fristDouble,textField: firstTextField)
            
        }
        if let secondDouble = secondTextField.text{
            secondNumber = conv.textToDouble(text: secondDouble,textField: secondTextField)
        }
        if let currenceText = currenceTextField.text{
            currence = conv.textToDouble(text: currenceText, textField: currenceTextField)
        }
        
        if textField == firstTextField, firstNumber != nil, currence != nil{
            secondTextField.text = String(conv.appLogic(count: firstNumber!, currency: currence!, scale: 1, round: nil))
        }
        if textField == secondTextField, secondNumber != nil, currence != nil{
            firstTextField.text = String(conv.appLogic(count: secondNumber!, currency: 1/currence!, scale: 1, round: nil))
        }
        if textField == currenceTextField, firstNumber != nil, currence != nil{
            secondTextField.text = String(conv.appLogic(count: firstNumber!, currency: currence!, scale: 1, round: nil))
        }
        data.currentCustomConverter[0] = firstTextField.text
        data.currentCustomConverter[1] = currenceTextField.text
        data.currentCustomConverter[2] = secondTextField.text
    }
    
    
    @objc func getKeyboardHeight(notification:Notification){
        if let keyboardFrame: NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height + 20
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


