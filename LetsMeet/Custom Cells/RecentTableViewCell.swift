//
//  RecentTableViewCell.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/16.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadMessageCountLabel: UILabel!
    @IBOutlet weak var unreadMessageBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unreadMessageBackgroundView.layer.cornerRadius = unreadMessageBackgroundView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func generateCell() {
        
    }
    
    private func setAvatar(avatarLink: String) {
        
    }
}
