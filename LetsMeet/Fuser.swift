//
//  Fuser.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/26.
//

import Foundation
import Firebase

class Fuser: Equatable {
    static func == (lhs: Fuser, rhs: Fuser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String = ""
    
    
    class func regiterUserWith(email: String, password: String, userName: String, city: String, isMale: Bool, dateOfBirth: Date, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
           
            completion(error)
            
            if error == nil {
                authData!.user.sendEmailVerification { error in
                    print("auth email berification sent", error?.localizedDescription)
                }
            }
        }
    }
}
