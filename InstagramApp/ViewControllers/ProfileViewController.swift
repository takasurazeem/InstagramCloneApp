//
//  ProfileViewController.swift
//  InstagramApp
//
//  Created by Gwinyai on 17/10/2018.
//  Copyright © 2018 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

enum ProfileType {

    case personal, otherUser

}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = [Post]()
    var profileType: ProfileType = .personal
    var user: UserModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        loadData()
    }

    // FIXME: - Add me in my controller later please.
    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else { Helper.logout(); return }
        let userRef = UserModel.collection.document(userId)
        // TODO: - Have second thoughts on having a spinner here for loading or use skeleton view.
        userRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            guard let user = UserModel(data) else { return }
            self.user = user
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return 3

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {

            return 1

        } else if section == 1 {

            return 1

        } else {

            return posts.count

        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let profileHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTableViewCell") as! ProfileHeaderTableViewCell
            profileHeaderTableViewCell.profileType = profileType
            if let user = user {
                profileHeaderTableViewCell.nameLabel.text = user.username
            }

            switch profileType {

            case .otherUser:

                profileHeaderTableViewCell.profileButton.setTitle("Follow", for: .normal)

            case .personal:

                profileHeaderTableViewCell.profileButton.setTitle("Logout", for: .normal)

                profileHeaderTableViewCell.profileButton.setTitleColor(UIColor.red, for: .normal)

            }

            return profileHeaderTableViewCell

        } else if indexPath.section == 1 {

            let profileViewStyleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewStyleTableViewCell") as! ProfileViewStyleTableViewCell

            return profileViewStyleTableViewCell

        } else if indexPath.section == 2 {

            let feedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell

            return feedTableViewCell

        } else {

            return UITableViewCell()

        }

    }

}
