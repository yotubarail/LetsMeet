//
//  UserCard.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/04.
//

import Foundation
import Shuffle_iOS

class UserCard: SwipeCard {
    
    private func configure(withmodel model: UserCardModel) {
        content = UserCardContentView(withImage: model.image)
        footer = UserCardFooterView(title: "\(model.name), \(model.age)", subtitle: model.occupation)
    }
}
