//
//  CardView.swift
//  SwipeCards
//
//  Created by Richard Price on 15/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageName)
            informationLable.attributedText = cardViewModel.attributedString
            informationLable.textAlignment = cardViewModel.textAlignment
        }
    }
    
    private let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    private let gradient = CAGradientLayer()
    private let informationLable = UILabel()
    
    //configurations
    let thresHold: CGFloat = 100
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)

    }
    fileprivate func setupGradientLayer() {
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.6, 1]
        layer.addSublayer(gradient)
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 20
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        
        setupGradientLayer()
        
        addSubview(informationLable)
        informationLable.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        informationLable.numberOfLines = 0
        informationLable.textColor = .white
    }
    
    override func layoutSubviews() {
        //executed when frame is drawn on load
        gradient.frame = self.frame
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {

        switch gesture.state {
        case .began:
            //fixes bug in animation when sliding cards off, this stops them return to the view
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        //rotation
        //convert radiens to degrees
        let translation = gesture.translation(in: nil)
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        let rotationTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        //should we dismis?
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > thresHold

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
            self.removeFromSuperview()
            }
            
            //self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
