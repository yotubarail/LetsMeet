//
//  FirebaseListner.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/27.
//

import Foundation
import FirebaseFirestore


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
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLocally()
                user.getUserAvatarFromFirebase { (didset) in
                    
                }
                
            } else {
                // first Login
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    FUser(_dictionary: user as! NSDictionary).saveUserToFirestore()
                }
            }
        }
    }

    func downloadUsersFromFirebase(isInitialLoad: Bool, limit: Int, lastDocumentSnapshot: DocumentSnapshot?, completion: @escaping (_ users: [FUser], _ snapshot: DocumentSnapshot?) -> Void) {
        
        var query: Query!
        var users: [FUser] = []
        
        if isInitialLoad {
            query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: false).limit(to: limit)
            print("first\(limit)")
        } else {
            if lastDocumentSnapshot != nil {
                query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: false).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                print("next \(limit) user loading")
            } else {
                print("lastsnapshot is nil")
            }
        }
        if query != nil {
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {return}
                
                if !snapshot.isEmpty {
                    for userData in snapshot.documents {
                        let userObject = userData.data() as NSDictionary
                        
                        if !(FUser.currentUser()?.likedIdArray?.contains(userObject [kOBJECTID] as! String) ?? false) && FUser.currentID() != userObject[kOBJECTID] as! String{
                            users.append(FUser(_dictionary: userObject))
                        }
                    }
                    completion(users, snapshot.documents.last!)
                } else {
                    print("no more users to fetch")
                    completion(users, nil)
                }
            }
        } else {
            completion(users, nil)
        }
    }
    
    //MARK: - Likes
    func checkIfUserLikedUs(userId: String, completion: @escaping(_ didLike: Bool) -> Void) {
        FirebaseReference(.Like).whereField(kLIKEDUSERID, isEqualTo: FUser.currentID()).whereField(kUSERID, isEqualTo: userId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            completion(snapshot.isEmpty)
        }
    }
}
