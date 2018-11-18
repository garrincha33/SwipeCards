//
//  CardViewModel.swift
//  SwipeCards
//
//  Created by Richard Price on 16/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment ) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    private var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    //setup observer for cardView, reactive
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
     func gotoNextPhoto() {
        imageIndex  = min(imageIndex + 1, imageNames.count-1)
    }
    
     func gotoPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}




