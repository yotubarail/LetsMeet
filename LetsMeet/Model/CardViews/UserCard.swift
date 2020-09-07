//
//  UserCard.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/04.
//

import Foundation
import Shuffle_iOS

class UserCard: SwipeCard {
    
    func configure(withModel model: UserCardModel) {
        content = UserCardContentView(withImage: model.image)
        footer = UserCardFooterView(withTitle: "\(model.name), \(model.age)", subtitle: model.occupation)
    }
}
