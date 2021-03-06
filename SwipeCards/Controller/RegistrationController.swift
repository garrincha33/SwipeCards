//
//  RegistrationController.swift
//  SwipeCards
//
//  Created by Richard Price on 19/11/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true, completion: nil)
    }
 
}

class RegistrationController: UIViewController {
    
    //MARK:- UI Components
    let gradientLayer = CAGradientLayer()
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    let fullNameTextField: UITextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Full name"
        tf.backgroundColor = .white
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Email"
        tf.backgroundColor = .white
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .normal)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupViewModelObserver()
        view.backgroundColor = .red
    }
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        print("register user")
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print(err)
                self.showHUDWithError(error: err)
                return
            }
            print("success, registered user", res?.user.uid ?? "")
        }
    }
    
    //MARK:- imagePicker
    @objc fileprivate func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
  
    }
    
    //MARK:- HUD
    fileprivate func showHUDWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    //MARK:- Keyboard observers
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
        
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //prevent retain cycle and remove yourself from the view
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notication: Notification) {
        guard let value = notication.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    //MARK:- textField recogniser
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupViewModelObserver() {
        
        registrationViewModel.bindableIsFormValidObserver.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else {return}
            
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                self.registerButton.setTitleColor(.darkGray, for: .normal)
            }
        }
        registrationViewModel.bindableImage.observer = {[unowned self] img in
            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    //MARK:- UI Stackviews
    lazy var overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    //MARK:- Setup layout
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        view.addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    //MARK:- gradientBackground
    fileprivate func superGradientLayer() {
        let topColor = #colorLiteral(red: 0.9864671826, green: 0.3463811278, blue: 0.3830411434, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8999838233, green: 0.124706693, blue: 0.4600698352, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
}
