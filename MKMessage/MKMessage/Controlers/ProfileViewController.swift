//
//  ProfileViewController.swift
//  MKMessage
//
//  Created by Upetch Ventures on 16/07/20.
//  Copyright © 2020 Upetch Ventures. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableProfile: UITableView!
    
    var data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableProfile.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableProfile.delegate = self
        tableProfile.dataSource = self
        
    }
    
}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let action = UIAlertController(title: "",
                                       message: "",
                                       preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Log Out",
                                       style: .destructive,
                                       handler: { [weak self] _ in
                                        guard let StrongSelf = self else{
                                            return
                                        }
                                        do {
                                            try FirebaseAuth.Auth.auth().signOut()
                                            let VC = LoginViewController()
                                            let nav = UINavigationController(rootViewController: VC)
                                            nav.modalPresentationStyle = .fullScreen
                                            StrongSelf.present(nav, animated: true)
                                        } catch {
                                            print("Failed")
                                        }
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(action, animated: true)
    }
}
