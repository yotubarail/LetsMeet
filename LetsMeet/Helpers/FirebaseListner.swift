//
//  FirebaseListner.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/27.
//

import Foundation
import Firebase


class FirebaseListner {
    static let shared = FirebaseListner()
    
    private init() {
        
    }
    
    //MARK: - FUser
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        FirebaseReference(.User).document(userId).getDocument{(snapshot, error) in
            guard let snapshot = snapshot else {
                return
            }
            if snapshot.exists {
                let user = Fuser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLobally()
            } else {
                // first Login
                if let user = userDeafults.object(forKey: kCURRENTUSER) {
                    Fuser(_dictionary: user as! NSDictionary).saveUserToFirestore()
                }
            }
        }
    }
}
