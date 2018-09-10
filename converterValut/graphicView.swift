//
//  graphicView.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 09.09.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import UIKit

class graphicView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var graphicData = [Double](){
        didSet{
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect){
        if graphicData.count > 0{
            var maxValue = graphicData[0]
            var minValue = maxValue
            for index in graphicData.indices{
                if maxValue < graphicData[index]{
                    maxValue = graphicData[index]
                }
                if minValue > graphicData[index]{
                    minValue = graphicData[index]
                }
            }
        
            let graphicDelta = maxValue - minValue
        
            //(value - minvalue)/graphicdelta
            let downGraphBoundsY = bounds.maxY - constants.deltaYForText - constants.offsetForMinMaxBounds
        
            let graphic = UIBezierPath()
            let startPoint = CGP(0,bounds.maxY - ((downGraphBoundsY) * CGFloat((graphicData[0]-minValue)/graphicDelta)+constants.deltaYForText))
            graphic.move(to: startPoint)
        
            for index in graphicData.indices{
                let point = CGP((bounds.maxX/CGFloat(graphicData.count)) * CGFloat(index),bounds.maxY - ((downGraphBoundsY * CGFloat((graphicData[index]-minValue)/graphicDelta)) + constants.deltaYForText))
                graphic.addLine(to: point)
            }
            UIColor.black.setStroke()
            graphic.lineWidth = constants.graphicWidth
            graphic.stroke()
        }
    }
}

extension graphicView{
    func CGP(_ x:CGFloat, _ y:CGFloat)->CGPoint{
        return CGPoint(x: x, y: y)
    }
    
    struct constants {
        static let textFontSize:CGFloat = 15
        static let deltaYForText:CGFloat = 20
        static let axesWidth:CGFloat = 1.5
        static let offsetForMinMaxBounds:CGFloat = 20
        static let graphicWidth:CGFloat = 1
    }
}
