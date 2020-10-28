//
//  MatchObject.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/11.
//

import Foundation

struct MatchObject {
    let id: String
    let memberIds: [String]
    let date: Date

    var dictionary: [String: Any] {
        return [kOBJECTID: id, kMEMBERIDS: memberIds, kDATE: date]
    }

    func saveToFirestore() {
        FirebaseReference(.Match).document(self.id).setData(self.dictionary)
    }
}
