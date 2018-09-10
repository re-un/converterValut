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
    var separator = UIView()
    var currentXSeparatorPosition:CGFloat = 0
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
    @IBAction func tapOnGraph(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .began,.changed,.ended:
            var point = sender.location(in: grView)
            point.y = 10
            separator.frame = CGRect(origin: point, size: separator.frame.size)
            separator.isHidden = false
            currentXSeparatorPosition = separator.frame.origin.x
            var elementOfArray = Int(currentXSeparatorPosition/grView.bounds.maxX*CGFloat(dataGraph.count))
            elementOfArray = dataGraph.count - elementOfArray - 1
            print("current \(currentXSeparatorPosition), grviewmaxX \(grView.bounds.maxX)")
            print(elementOfArray)
            curAbbreviationLabel.text = String(dataGraph[elementOfArray].Cur_OfficialRate) + " " + data.dateToString(date: dataGraph[elementOfArray].Date, dateFormat: "dd MMM")
        default:
            break
        }
    }
    @IBAction func tapOnScreen(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            var point = sender.location(in: grView)
            point.y = 10
            separator.frame = CGRect(origin: point, size: separator.frame.size)
            separator.isHidden = false
            currentXSeparatorPosition = separator.frame.origin.x
            let elementOfArray = Int(currentXSeparatorPosition/grView.bounds.maxX * CGFloat(dataGraph.count - 1))
            print("current \(currentXSeparatorPosition)")
            print(elementOfArray)
            curAbbreviationLabel.text = String(dataGraph[elementOfArray].Cur_OfficialRate) + " " + data.dateToString(date: dataGraph[elementOfArray].Date, dateFormat: "dd MMM")
        default:
            break
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
        separator = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: view.frame.maxY))
        separator.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        grView.addSubview(separator)
        separator.isHidden = true
        spinner.startAnimating()
        // Do any additional setup after loading the view.
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            self?.dataGraph = data.getDataForGraph(curAbbreviation: (self?.curAbbreviation)!)
        }
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
