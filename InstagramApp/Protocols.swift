//
//  Protocols.swift
//  InstagramApp
//
//  Created by Gwinyai on 18/1/2019.
//  Copyright © 2019 Gwinyai Nyatsoka. All rights reserved.
//

import Foundation

protocol FeedDataDelegate: AnyObject {
    func commentsDidTouch(post: Post)
}

protocol ProfileDelegate: AnyObject {
    func userNameDidTouch()
}

protocol ActivityDelegate: AnyObject {
    func scrollTo(index: Int)
    func activityDidTouch()
}

protocol ProfileHeaderDelegate: AnyObject {
    func profileImageDidTouch()
}
