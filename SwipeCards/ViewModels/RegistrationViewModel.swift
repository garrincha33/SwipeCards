//
//  RegistrationViewModel.swift
//  SwipeCards
//
//  Created by Richard Price on 18/12/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    var fullName: String? {didSet {checkFormValidilty()} }
    var email: String? {didSet {checkFormValidilty()} }
    var password: String? {didSet {checkFormValidilty()} }
    
    fileprivate func checkFormValidilty() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValidObserver.value = isFormValid
    }

    //reactive observer
    
    var bindableIsFormValidObserver = Bindable<Bool>()
    
    //var isFormValidObserver: ((Bool) -> ())?

}

