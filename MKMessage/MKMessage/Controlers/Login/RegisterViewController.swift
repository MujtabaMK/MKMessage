//
//  RegisterViewController.swift
//  MKMessage
//
//  Created by Upetch Ventures on 16/07/20.
//  Copyright © 2020 Upetch Ventures. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let scrollview: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.clipsToBounds = true
        return scrollview
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let firsttxt: UITextField = {
        let emailtxt = UITextField()
        emailtxt.autocapitalizationType = .none
        emailtxt.autocorrectionType = .no
        emailtxt.returnKeyType = .continue
        emailtxt.layer.cornerRadius = 12
        emailtxt.layer.borderWidth = 1
        emailtxt.layer.borderColor = UIColor.lightGray.cgColor
        emailtxt.placeholder = "First Name"
        emailtxt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailtxt.leftViewMode = .always
        emailtxt.backgroundColor = .white
        return emailtxt
    }()
    
    private let lasttxt: UITextField = {
        let emailtxt = UITextField()
        emailtxt.autocapitalizationType = .none
        emailtxt.autocorrectionType = .no
        emailtxt.returnKeyType = .continue
        emailtxt.layer.cornerRadius = 12
        emailtxt.layer.borderWidth = 1
        emailtxt.layer.borderColor = UIColor.lightGray.cgColor
        emailtxt.placeholder = "Last Name"
        emailtxt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailtxt.leftViewMode = .always
        emailtxt.backgroundColor = .white
        return emailtxt
    }()
    
    private let emailtxt: UITextField = {
        let emailtxt = UITextField()
        emailtxt.autocapitalizationType = .none
        emailtxt.autocorrectionType = .no
        emailtxt.returnKeyType = .continue
        emailtxt.layer.cornerRadius = 12
        emailtxt.layer.borderWidth = 1
        emailtxt.layer.borderColor = UIColor.lightGray.cgColor
        emailtxt.placeholder = "Email Address"
        emailtxt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailtxt.leftViewMode = .always
        emailtxt.backgroundColor = .white
        return emailtxt
    }()
    
    private let passwordtxt: UITextField = {
        let passwordtxt = UITextField()
        passwordtxt.autocapitalizationType = .none
        passwordtxt.autocorrectionType = .no
        passwordtxt.isSecureTextEntry = true
        passwordtxt.returnKeyType = .done
        passwordtxt.layer.cornerRadius = 12
        passwordtxt.layer.borderWidth = 1
        passwordtxt.layer.borderColor = UIColor.lightGray.cgColor
        passwordtxt.placeholder = "Password"
        passwordtxt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordtxt.leftViewMode = .always
        passwordtxt.backgroundColor = .white
        return passwordtxt
    }()
    
    private let Button: UIButton = {
        let Button = UIButton()
        Button.setTitle("Register", for: .normal)
        Button.backgroundColor = .link
        Button.setTitleColor(.white, for: .normal)
        Button.layer.cornerRadius = 12
        Button.layer.masksToBounds = true
        Button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return Button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapNavigationButton))
        
        emailtxt.delegate = self
        passwordtxt.delegate = self
        firsttxt.delegate = self
        lasttxt.delegate = self
        Button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        let Gasture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        Gasture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(Gasture)
        
        imageView.isUserInteractionEnabled = true
        scrollview.isUserInteractionEnabled = true
        
        //Add Subview
        view.addSubview(scrollview)
        scrollview.addSubview(imageView)
        scrollview.addSubview(emailtxt)
        scrollview.addSubview(passwordtxt)
        scrollview.addSubview(Button)
        scrollview.addSubview(firsttxt)
        scrollview.addSubview(lasttxt)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollview.frame = view.bounds
        let Size = scrollview.Width/3
        imageView.frame = CGRect(x: (scrollview.Width-Size)/2,
                                 y: 20,
                                 width: Size,
                                 height: Size)
        imageView.layer.cornerRadius = imageView.Width/2.0
        firsttxt.frame = CGRect(x: 30,
                                y: imageView.Bottom + 20,
                                width: scrollview.Width - 60,
                                height: 51)
        lasttxt.frame = CGRect(x: 30,
                               y: firsttxt.Bottom + 10,
                               width: scrollview.Width - 60,
                               height: 51)
        emailtxt.frame = CGRect(x: 30,
                                y: lasttxt.Bottom + 10,
                                width: scrollview.Width - 60,
                                height: 51)
        passwordtxt.frame = CGRect(x: 30,
                                   y: emailtxt.Bottom + 10,
                                   width: scrollview.Width - 60,
                                   height: 51)
        Button.frame = CGRect(x: 30,
                              y: passwordtxt.Bottom + 10,
                              width: scrollview.Width - 60,
                              height: 51)
    }
    
    @objc private func didTapProfilePic(){
        presentPhotoActionSheet()
    }
    
    @objc private func didTapButton(){
        firsttxt.resignFirstResponder()
        lasttxt.resignFirstResponder()
        emailtxt.resignFirstResponder()
        passwordtxt.resignFirstResponder()
        guard let email = emailtxt.text , let password = passwordtxt.text, let First = firsttxt.text, let Last = lasttxt.text, !First.isEmpty, !Last.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else{
            alertUserLoginError()
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, Error in
            guard let result = authResult, Error == nil else{
                return
            }
            let UserCreate = result.user
            print("Created User \(UserCreate)")
            
            
        })
        
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Opps", message: "Please Enter All Info to Register", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapNavigationButton(){
        let VC = RegisterViewController()
        VC.title = "Create Account"
        navigationController?.pushViewController(VC, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firsttxt{
            lasttxt.becomeFirstResponder()
        }else if textField == lasttxt{
            emailtxt.becomeFirstResponder()
        }else if textField == emailtxt{
            passwordtxt.becomeFirstResponder()
        }else if textField == passwordtxt{
            didTapButton()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How Would you like to select profile picture",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.CameraPhoto()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.LibaryPhoto()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func CameraPhoto(){
        let VC = UIImagePickerController()
        VC.sourceType = .camera
        VC.delegate = self
        VC.allowsEditing = true
        present(VC, animated: true)
    }
    
    func LibaryPhoto(){
        let VC = UIImagePickerController()
        VC.sourceType = .photoLibrary
        VC.delegate = self
        VC.allowsEditing = true
        present(VC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let SelectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        imageView.image = SelectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

