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
    
    func appLogic(count: Double, currency:Double, scale:Int, round:Int?)->Double{
        return round != nil ? (count*currency*Double(scale)).rounded(toPlaces: round!): count*currency*Double(scale)
    }
}
