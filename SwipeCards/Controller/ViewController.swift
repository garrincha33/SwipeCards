//
//  ViewController.swift
//  SwipeCards
//
//  Created by Richard Price on 14/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let blueView = UIView()
    let buttonStackView = HomeButtonControlsStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        blueView.backgroundColor = .blue
        setupLayout()
    }
    
    //MARK:- FilePrivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

