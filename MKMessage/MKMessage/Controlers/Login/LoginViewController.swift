//
//  LoginViewController.swift
//  MKMessage
//
//  Created by Upetch Ventures on 16/07/20.
//  Copyright © 2020 Upetch Ventures. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

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
    
    private let loginButton: FBLoginButton = {
        let LoginButton = FBLoginButton()
        LoginButton.permissions = ["email,public_profile"]
        return LoginButton
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapNavigationButton))
        
        emailtxt.delegate = self
        passwordtxt.delegate = self
        loginButton.delegate = self
        Button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        //Add Subview
        view.addSubview(scrollview)
        scrollview.addSubview(imageView)
        scrollview.addSubview(emailtxt)
        scrollview.addSubview(passwordtxt)
        scrollview.addSubview(Button)
        scrollview.addSubview(loginButton)
        
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
        loginButton.frame = CGRect(x: 30,
                              y: Button.Bottom + 10,
                              width: scrollview.Width - 60,
                              height: 51)
    }
    
    //MARK:- DidTapButton
    
    @objc private func didTapButton(){
        emailtxt.resignFirstResponder()
        passwordtxt.resignFirstResponder()
        guard let email = emailtxt.text , let password = passwordtxt.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else{
            alertUserLoginError()
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, Error in
            guard let StorngSelf = self else{
                return
            }
            guard let result = authResult, Error == nil else{
                print("Failed to log In with email \(email)")
                return
            }
            let UserLogin = result.user
            print("Success login in with User \(UserLogin)")
            
            StorngSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    //MARK:-
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
extension LoginViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //No now
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else{
            print("User Failed to login with Facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start(completionHandler: { _, result, error in
            guard let result1 = result as? [String:Any], error == nil else{
                print("Failed to make graph request")
                return
            }
            
            guard let username = result1["name"] as? String,
                let email = result1["email"] as? String else{
                print("Failed to get email and name for facebook result")
                return
            }
            
            let namecomponent = username.components(separatedBy: " ")
            guard namecomponent.count == 2 else{
                return
            }
            let firstname = namecomponent[0]
            let lastname = namecomponent[1]
            
            DatabaseManager.shared.UserExist(with: email, completion: {exist in
                if !exist{
                    DatabaseManager.shared.insertuser(with: ChatAppUser(firstname: firstname,
                                                                        lastname: lastname,
                                                                        emailaddress: email))
                }
            })
            
            let Crediancial = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: Crediancial, completion: { [weak self]authResult , error in
                guard let strongself = self else{
                    return
                }
                guard authResult != nil, error == nil else{
                    if let error1 = error{
                        print("Facebook Crediantial Login Failed, MFA may be need  = \(error1)")
                    }
                    return
                }
                strongself.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}
