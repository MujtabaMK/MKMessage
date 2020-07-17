//
//  DatabaseManager.swift
//  MKMessage
//
//  Created by Upetch Ventures on 17/07/20.
//  Copyright © 2020 Upetch Ventures. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

//MARK: - Account Management

extension DatabaseManager{
   
    public func UserExist(with email: String, completion: @escaping ((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
   public func insertuser(with user: ChatAppUser){
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastname
        ])
    }
}

struct ChatAppUser {
    let firstname: String
    let lastname: String
    let emailaddress: String
    var safeEmail: String{
        var safeEmail = emailaddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
