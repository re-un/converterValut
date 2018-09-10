//
//  GraphicViewController.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 09.09.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import UIKit

class GraphicViewController: UIViewController {
    var curAbbreviation = ""
    var dlabels = [UILabel]()
    var months = ["","","","","",""]
    var dataGraph = [dataAlgorithm.graphCurrence](){
        didSet{
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            for index in dataGraph.indices{
                grView.graphicData += [dataGraph[index].Cur_OfficialRate]
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var curAbbreviationLabel: UILabel!{
        didSet{
            curAbbreviationLabel.text = curAbbreviation
        }
    }
    
    @IBOutlet weak var dateLabels: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        // Do any additional setup after loading the view.
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            self?.dataGraph = data.getDataForGraph(curAbbreviation: (self?.curAbbreviation)!)
        }
        
//        for index in data.dataForGraphic.indices{
//            grView.graphicData += [data.dataForGraphic[index].Cur_OfficialRate]
//        }
        dlabels = (dateLabels.arrangedSubviews as? [UILabel])!
        for index in dlabels.indices{
            let date = Calendar.current.date(byAdding: .month, value: index*2, to: Date())
            dlabels[dlabels.count - 1 - index].text = data.dateToString(date: date!, dateFormat: "MMM")
        }
    }
    
    @IBOutlet var grView: graphicView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
