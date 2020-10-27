//
//  FCollectionReference.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/27.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Like
    case Match
    case Recent
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
