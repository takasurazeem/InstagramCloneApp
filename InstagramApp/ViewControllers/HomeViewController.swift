//
//  HomeViewController.swift
//  InstagramApp
//
//  Created by Takasur A. on 26/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var posts: [Post] = {
        let model = Model()

        return model.postList
    }()

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")

        tableView.register(UINib(nibName: "StoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "StoriesTableViewCell")

        var rightBarItemImage = UIImage(named: "send_nav_icon")
        rightBarItemImage = rightBarItemImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarItemImage, style: .plain, target: nil, action: nil)

        var leftBarItemImage = UIImage(named: "camera_nav_icon")
        leftBarItemImage = leftBarItemImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .plain, target: nil, action: nil)

        let profileImageView = UIImageView(image: UIImage(named: "logo_nav_icon"))

        navigationItem.titleView = profileImageView
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        posts.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoriesTableViewCell", for: indexPath) as! StoriesTableViewCell

            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell

        let currentIndex = indexPath.row - 1

        let post = posts[currentIndex]

        cell.profileImage.image = post.user.profileImage

        cell.postImage.image = post.postImage

        cell.dateLabel.text = post.datePosted

        cell.likesCountLabel.text = "\(post.likesCount) likes"

        cell.usernameTitleButton.setTitle(post.user.name, for: .normal)

        cell.commentCountButton.setTitle("View all \(post.commentCount) comments", for: .normal)

        return cell
    }
}
