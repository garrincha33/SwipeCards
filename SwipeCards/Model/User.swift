//
//  User.swift
//  SwipeCards
//
//  Created by Richard Price on 16/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    
    let name: String
    let age: Int
    let profression: String
    let imageName: String
 
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n \(profression)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    }
    
}

