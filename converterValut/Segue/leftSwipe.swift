//
//  leftSwipe.swift
//  converterValut
//
//  Created by Andrew Lutinskyi on 03.09.2018.
//  Copyright © 2018 Andrew Lutinskyi. All rights reserved.
//

import UIKit

class leftSwipe: UIStoryboardSegue {
    override func perform() {
        animation()
    }
    func animation(){
        let toController = self.destination
        let fromController = self.source
        
        let containerView = fromController.view.superview
        toController.view.transform = CGAffineTransform.identity.translatedBy(x: -toController.view.bounds.maxY, y: 0)
        containerView?.addSubview(toController.view)
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: [.allowUserInteraction],
                       animations:{toController.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)},
                       completion:{succes in fromController.present(toController, animated: false, completion: nil)
        })
    }
}
