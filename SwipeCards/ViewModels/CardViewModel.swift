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


struct CardViewModel {
    
    //link between model and view
    
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
 
}




