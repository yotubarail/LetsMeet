//
//  GlobalFunctions.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/10.
//

import Foundation
import Firebase

//MARK: - Mathes
func removeCurrentUserIdFrom(userIds: [String]) -> [String] {
    var allIds = userIds
    
    for id in allIds {
        if id == FUser.currentId() {
            allIds.remove(at: allIds.firstIndex(of: id)!)
        }
    }
    return allIds
}


//MARK: - Like
func saveLikeToUser(userId: String) {
    let like = LikeObject(id: UUID().uuidString, userId: FUser.currentId(), likedUserId: userId, date: Date())
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

//MARK: - Starting chat
func startChat(user1: FUser, user2: FUser) -> String {
    
    let chatRoomId = chatRoomIdFrom(userId: user1.objectId, user2Id: user2.objectId)
    
    createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
    
    return chatRoomId
}

func chatRoomIdFrom(userId: String, user2Id: String) -> String {
    
    var chatRoomId = ""
    let value = userId.compare(user2Id).rawValue
    
    chatRoomId = value < 0 ? userId + user2Id : user2Id + userId
    
    return chatRoomId
}

//MARK: - RecentChats
func createRecentItems(chatRoomId: String, users: [FUser]) {
    
    var memberIdsToCreateRecent:[String] = []
    
    for user in users {
        memberIdsToCreateRecent.append(user.objectId)
    }
    
    FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, memberIds: memberIdsToCreateRecent)
        }
        
        for userId in memberIdsToCreateRecent {
            let senderUser = userId == FUser.currentId() ? FUser.currentUser()! : getReceiverFrom(users: users)
            
            let receiverUser = userId == FUser.currentId() ? getReceiverFrom(users: users) : FUser.currentUser()!
            
            let recentObject = RecentChat()
            
            recentObject.objectId = UUID().uuidString
            recentObject.chatRoomId = ""
            recentObject.senderId = senderUser.objectId
            recentObject.senderName = senderUser.username
            recentObject.receiverId = receiverUser.objectId
            recentObject.receiverName = receiverUser.username
            recentObject.date = Date()
            recentObject.memberIds = [senderUser.objectId, receiverUser.objectId]
            
            recentObject.lastMessage = ""
            recentObject.unreadCounter = 0
            recentObject.avatarLink = receiverUser.avatarLink
            
            recentObject.saveToFireStore()
        }
    }
}

func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
    
    var memberIdsToCreateRecent = memberIds
    
    for recentData in snapshot.documents {
        
        let currentRecent = recentData.data() as Dictionary
        
        if let currentUserId = currentRecent[kSENDERID] {
            if memberIdsToCreateRecent.contains(currentUserId as! String) {
                let index = memberIdsToCreateRecent.firstIndex(of: currentUserId as! String)!
                memberIdsToCreateRecent.remove(at: index)
            }
        }
    }
    
    return memberIdsToCreateRecent
}

func getReceiverFrom(users: [FUser]) -> FUser {
    var allUsers = users
    
    allUsers.remove(at: allUsers.firstIndex(of: FUser.currentUser()!)!)
    
    
    return allUsers.first!
}
