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
    
    func brain(_ textField:UITextField){
        var firstNumber:Double?
        var secondNumber:Double?
        var currence:Double?
        firstNumber = converter.textToDouble(textField: firstTextField);
        secondNumber = converter.textToDouble(textField: secondTextField);
        currence = converter.textToDouble(textField: currenceTextField);
        
        switch(textField){
        case firstTextField:
            if firstNumber == nil{
                secondTextField.text = ""
                break
            }
            if currence == nil {
                break
            }
            secondTextField.text = String(converter.appLogic(count: firstNumber!, currency: currence!, scale: 1, round: nil))
        case secondTextField:
            if secondNumber == nil{
                firstTextField.text = ""
                break;
            }
            if currence == nil {
                break
            }
            firstTextField.text = String(converter.appLogic(count: secondNumber!, currency: 1/currence!, scale: 1, round: nil))
        case currenceTextField:
            if firstNumber == nil || currence == nil{
                break
            }
            secondTextField.text = String(converter.appLogic(count: firstNumber!, currency: currence!, scale: 1, round: nil))
        default:
            break
        }
        data.currentCustomConverter = [firstTextField.text, currenceTextField.text, secondTextField.text];
    }
    
    
    @objc func getKeyboardHeight(notification:Notification){
        if let keyboardFrame: NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height + 20
        }
    }
}


