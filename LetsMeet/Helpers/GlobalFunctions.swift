//
//  GlobalFunctions.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/10.
//

import Foundation

//MARK: - Like
func saveLikeToUser(userId: String) {
    let like = LikeObject(id: UUID().uuidString, userId: FUser.currentID(), likedUserId: userId, date: Date())
    like.saveToFirestore()
    
    if let currentUser = FUser.currentUser() {
        if !didLikeUserWith(userID: userId) {
          currentUser.likedIdArray!.append(userId)
          currentUser.updateCurrentUserInFirestore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray!]) { (error) in
          print("Updated current user with error", error?.localizedDescription)
          }
        }
    }
}

func didLikeUserWith(userID: String) -> Bool {
    return FUser.currentUser()?.likedIdArray?.contains(userID) ?? false
}
