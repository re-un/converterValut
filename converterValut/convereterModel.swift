//
//  convereterModel.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 05.09.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import Foundation
import UIKit

class converter{
    var keyboardHeight:CGFloat = 0
    static func textToDouble(textField:UITextField)->Double?{
        if textField.text == nil {
            return nil
        }
        let text = textField.text!
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
    
    static func appLogic(count: Double, currency:Double, scale:Int, round:Int?)->Double{
        return round != nil ? (count/currency*Double(scale)).rounded(toPlaces: round!): count/currency*Double(scale)
    }
}
