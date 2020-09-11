//
//  LikeObject.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/09.
//

import Foundation

struct LikeObject {
    let id: String
    let userId: String
    let likedUserId: String
    let date: Date
    
    var dictionary: [String: Any] {
        return [kOBJECTID: id, kUSERID: userId, kLIKEDUSERID: likedUserId, kDATE: date]
    }
    
    func saveToFirestore() {
        FirebaseReference(.Like).document(self.id).setData(self.dictionary)
    }
}
