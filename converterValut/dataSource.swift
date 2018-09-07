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
        var Date:Date
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
    
    var currentNacBankValues = Array<String?>(repeating: nil, count: 2)
    var currentCustomConverter = Array<String?>(repeating: nil, count: 3)
    
    var urlForSave:URL?
    //Date    String    "2018-09-07T00:00:00"
    
    func stringToDate(dateString:String)->Date{
        //let isoDate = "2016-04-14T10:44:00+0000"
        let newString = dateString + "+0000"
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:newString)!
        return date
    }
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    let decoder = JSONDecoder()
    let formater = DateFormatter()
    
    func getAllCurrences(){
        if let url = URL(string: callForAllCurrences){
            if let data = try? Data(contentsOf: url){
                try? data.write(to: urlForSave!)
                if let currnces = try? decoder.decode([currence].self, from: data){
                    self.allCurrences = currnces
                }
            }
            setCurrences(&lessCurrneces, &allCurrences)
        }
    }
    
    func setCurrences(_ lessCur: inout [currence], _ allCur: inout [currence]){
        lessCur = allCur.filter{$0.Cur_Abbreviation=="UAH"||$0.Cur_Abbreviation=="USD"||$0.Cur_Abbreviation=="EUR"||$0.Cur_Abbreviation=="RUB"}
        lessCur.swapAt(0, 3)
        allCur.sort(by: <)
    }
    
    func checkIfNeedUpdate()->Bool{
        formater.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formater)
        
        urlForSave = try? FileManager.default.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory , in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("currences", isDirectory: false)
        if let JSONData = try? Data(contentsOf: urlForSave!){
            if let currnces = try? decoder.decode([currence].self, from: JSONData){
                self.allCurrences = currnces
                print("get from filesystem")
            }
        }
        if allCurrences.count == 0{
            return true
        }
        setCurrences(&lessCurrneces, &allCurrences)
        let updateDate = allCurrences[0].Date
        return Calendar.current.compare(updateDate, to: Date(), toGranularity: .day) != .orderedSame
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
