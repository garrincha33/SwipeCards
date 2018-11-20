//
//  Advertiser.swift
//  SwipeCards
//
//  Created by Richard Price on 16/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterName: String

    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]))
        return CardViewModel(imageNames: [posterName], attributedString: attributedString, textAlignment: .center)
    }
}


