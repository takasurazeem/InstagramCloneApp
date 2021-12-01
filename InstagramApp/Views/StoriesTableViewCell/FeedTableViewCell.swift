//
//  FeedTableViewCell.swift
//  InstagramApp
//
//  Created by Takasur A. on 27/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameTitleButton: UIButton!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var postCommentLabel: UILabel!
    @IBOutlet var commentCountButton: UIButton!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
