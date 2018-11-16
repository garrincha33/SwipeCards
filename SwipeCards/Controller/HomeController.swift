//
//  HomeController.swift
//  SwipeCards
//
//  Created by Richard Price on 14/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeButtonControlsStackView()

    let cardViewModels = [
        User(name: "Kelly", age: 23, profression: "Music DJ", imageName: "lady5c").toCardViewModel(),
        User(name: "Jane", age: 18, profression: "Teacher", imageName: "lady4c").toCardViewModel()
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    //MARK:- FilePrivate
    fileprivate func setupDummyCards() {
        
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardViewModel.imageName)
            cardView.informationLable.attributedText = cardViewModel.attributedString
            cardView.informationLable.textAlignment = cardViewModel.textAlignment
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
        
    }
}

