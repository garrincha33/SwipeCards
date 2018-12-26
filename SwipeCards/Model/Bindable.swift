//
//  Bindable.swift
//  SwipeCards
//
//  Created by Richard Price on 26/12/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
