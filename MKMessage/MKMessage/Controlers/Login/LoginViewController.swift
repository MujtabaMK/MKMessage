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
        return emailtxt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapNavigationButton))
        
        //Add Subview
        view.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let Size = view.Width/3
        imageView.frame = CGRect(x: (view.Width-Size)/2,
                                 y: 20,
                                 width: Size,
                                 height: Size)
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
