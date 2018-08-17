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
    }
    
    private struct allcur:Codable {
        var allCurrences:[currence]
    }
    
    var allCurrences = [currence]()
    func getAllCurrences(){
        if let url = URL(string: callForAllCurrences){
            URLSession.shared.dataTask(with: url){
                (data,response,err) in
                if let dat = data{
                    if let currnces = try? JSONDecoder().decode([currence].self, from: dat){
                        self.allCurrences = currnces
                    }
                }
            }.resume()
        }
    }
}

