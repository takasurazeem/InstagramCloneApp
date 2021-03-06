//
//  UserData.swift
//  InstagramApp
//
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct User {
    var name: String

    var profileImage: UIImage
}

class UsersModel {
    var users = [User]()

    init() {
        let user1 = User(name: "John Carmack", profileImage: UIImage(named: "user1")!)

        users.append(user1)

        let user2 = User(name: "Bjarne Stroustrup", profileImage: UIImage(named: "user2")!)

        users.append(user2)
    }
}

// FIXME: - Make it a struct here and Codable
class UserModel {
    // FIXME: - Put me in some globals file perhaps or somewhere in VM/C/P whatever.
    // FIXME: - Fix smells of hard coded keys everywhere, create an enum for all and document them.
    static var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }

    var username: String?
    var bio: String?
    var profileImage: URL?

    init?(_ data: [String: Any]?) {
        guard let data = data else {
            return
        }
        username = data["username"] as? String
        bio = data["bio"] as? String
        if let profileImage = data["profileImage"] as? String {
            self.profileImage = URL(string: profileImage)
        }
    }
}
