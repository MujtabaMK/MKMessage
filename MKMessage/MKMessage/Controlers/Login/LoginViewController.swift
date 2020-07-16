//
//  LoginViewController.swift
//  MKMessage
//
//  Created by Upetch Ventures on 16/07/20.
//  Copyright © 2020 Upetch Ventures. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let scrollview: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.clipsToBounds = true
        return scrollview
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Facebook_Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        Button.setTitle("Log In", for: .normal)
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
        Button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        //Add Subview
        view.addSubview(scrollview)
        scrollview.addSubview(imageView)
        scrollview.addSubview(emailtxt)
        scrollview.addSubview(passwordtxt)
        scrollview.addSubview(Button)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollview.frame = view.bounds
        let Size = scrollview.Width/3
        imageView.frame = CGRect(x: (scrollview.Width-Size)/2,
                                 y: 20,
                                 width: Size,
                                 height: Size)
        emailtxt.frame = CGRect(x: 30,
                                y: imageView.Bottom + 40,
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
    
    @objc private func didTapButton(){
        emailtxt.resignFirstResponder()
        passwordtxt.resignFirstResponder()
        guard let email = emailtxt.text , let password = passwordtxt.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else{
            alertUserLoginError()
            return
        }
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Opps", message: "Please Enter All Info to Log In", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapNavigationButton(){
        let VC = RegisterViewController()
        VC.title = "Create Account"
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailtxt{
            passwordtxt.becomeFirstResponder()
        }else if textField == passwordtxt{
            didTapButton()
        }
        return true
    }
}
