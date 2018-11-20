//
//  HomeController.swift
//  SwipeCards
//
//  Created by Richard Price on 14/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    private let topStackView = TopNavigationStackView()
    private let cardsDeckView = UIView()
    private let buttonStackView = HomeButtonControlsStackView()
    
    private let cardViewModels: [CardViewModel] = {
        let producers = [
            User(name: "Kelly", age: 23, profression: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
            User(name: "Jane", age: 18, profression: "Teacher", imageNames: ["jane1", "jane2", "jane3"]),
            Advertiser(title: "IOS Developer", brandName: "richappcoder.com", posterName: "me")
        ] as [ProducesCardViewModel]
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupDummyCards()
    }
    
    //MARK:- FilePrivate
    @objc fileprivate func handleSettings() {
        print("reg page show")
        present(RegistrationController(), animated: true, completion: nil)
    }
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
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

