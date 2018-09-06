//
//  dataSource.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 17.08.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import Foundation

class dataAlgorithm {
    private let callForAllCurrences = "http://www.nbrb.by/API/ExRates/Rates?Periodicity=0"
   
    struct currence: Codable{
        var Cur_ID:Int
        var Date:String
        var Cur_Abbreviation:String
        var Cur_Scale:Int
        var Cur_Name:String
        var Cur_OfficialRate:Double
        static func <(left:currence, right:currence)->Bool{
            return left.Cur_Abbreviation < right.Cur_Abbreviation
        }
    }
    
    private struct allcur:Codable {
        var allCurrences:[currence]
    }
    
    var allCurrences = [currence]()
    var lessCurrneces = [currence]()
    var roundCount = [1,2,3,4,5,6,7,8,9]
    func getAllCurrences(){
        if let url = URL(string: callForAllCurrences){
            if let data = try? Data(contentsOf: url){
                if let currnces = try? JSONDecoder().decode([currence].self, from: data){
                    self.allCurrences = currnces
                    lessCurrneces = allCurrences.filter{$0.Cur_Abbreviation=="UAH"||$0.Cur_Abbreviation=="USD"||$0.Cur_Abbreviation=="EUR"||$0.Cur_Abbreviation=="RUB"}
                    lessCurrneces.swapAt(0, 3)
                    allCurrences.sort(by: <)
                }
            }
        }
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
