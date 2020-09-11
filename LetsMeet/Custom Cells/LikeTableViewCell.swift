//
//  LikeTableViewCell.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/11.
//

import UIKit

class LikeTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func setUpCell(user: FUser) {
        nameLabel.text = user.username
        setAvatar(avatarLink: user.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {
        FileStorage.downloadImage(imageUrl: avatarLink) { avatarImage in
            self.avatarImageView.image = avatarImage?.circleMasked
        }
    }
}
