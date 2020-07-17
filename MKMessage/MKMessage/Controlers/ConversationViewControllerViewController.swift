//
//  ViewController.swift
//  MKMessage
//
//  Created by Upetch Ventures on 15/07/20.
//  Copyright © 2020 Upetch Ventures. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ValidateAuth()
    }
    
    func ValidateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let VC = LoginViewController()
            let nav = UINavigationController(rootViewController: VC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
}

