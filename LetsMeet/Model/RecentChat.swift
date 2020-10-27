//
//  RecentChat.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/18.
//

import Foundation
import UIKit
import Firebase

class RecentChat {
    
    var objectId = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    var date = Date()
    var membetIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
    
    var avatarImage: UIImage?
    
    var dictionary: NSDictionary {
        return NSDictionary(objects: [objectId,
                                      chatRoomId,
                                      senderId,
                                      senderName,
                                      receiverId,
                                      receiverName,
                                      date,
                                      membetIds,
                                      lastMessage,
                                      unreadCounter,
                                      avatarLink
            
        ],
                            forKeys: [kOBJECTID as NSCopying,
                                      kCHATROOMID as NSCopying,
                                      kSENDERID as NSCopying,
                                      kSENDERNAME as NSCopying,
                                      kRECEIVERID as NSCopying,
                                      kRECEIVERNAME as NSCopying,
                                      kDATE as NSCopying,
                                      kMEMBERIDS as NSCopying,
                                      kLASTMESSAGE as NSCopying,
                                      kUNREADCOUNTER as NSCopying,
                                      kAVATARLINK as NSCopying
                            ])
    }
    
    init() {
        <#statements#>
    }
    
    init(_ recentDocument: Dictionary<String, Any>) {
        objectId = recentDocument[kOBJECTID] as? String ?? ""
        chatRoomId = recentDocument[kCHATROOMID] as? String ?? ""
        senderId = recentDocument[kSENDERID] as? String ?? ""
        senderName = recentDocument[kSENDERNAME] as? String ?? ""
        receiverId = recentDocument[kRECEIVERID] as? String ?? ""
        receiverName = recentDocument[kRECEIVERNAME] as? String ?? ""
        date = (recentDocument[kDATE] as? Timestamp)?.dateValue() ?? Date()
        membetIds = recentDocument[kMEMBERIDS] as? [String] ?? [""]
        lastMessage = recentDocument[kLASTMESSAGE] as? String ?? ""
        unreadCounter = recentDocument[kUNREADCOUNTER] as? Int ?? 0
        avatarLink = recentDocument[kAVATARLINK] as? String ?? ""
    }
    
    //MARK: - Saving
    func saveToFireStore() {
        FirebaseReference(.Recent).document(self.objectId).setData(self.dictionary as! [String: Any])
    }
    
    func deleteRecent(){
        FirebaseReference(.Recent).document(self.objectId).delete()
    }
}
