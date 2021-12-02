//
//  Helper.swift
//  InstagramApp
//
//  Created by Takasur A. on 02/12/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit
import FirebaseAuth

// FIXME: - Not sure if it is the right thing to do, will dig deeper later
let tabBarDelegate = TabBarDelegate()

class Helper {

    class func errorAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }

    class func login() {
        let tabController = UITabBarController()

        tabController.delegate = tabBarDelegate

        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)

        let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)

        let newPostStoryboard = UIStoryboard(name: "NewPost", bundle: nil)

        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)

        let activityStoryboard = UIStoryboard(name: "Activity", bundle: nil)

        let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController

        let searchVC = searchStoryboard.instantiateViewController(withIdentifier: "Search") as! SearchViewController

        let newPostVC = newPostStoryboard.instantiateViewController(withIdentifier: "NewPost") as! NewPostViewController

        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController

        let activityVC = activityStoryboard.instantiateViewController(withIdentifier: "Activity") as! ActivityViewController

        let vcData: [(UIViewController, UIImage, UIImage)] = [
            (homeVC,
             UIImage(named: "home_tab_icon")!,
             UIImage(named: "home_selected_tab_icon")!),
            (searchVC,
             UIImage(named: "search_tab_icon")!,
             UIImage(named: "search_selected_tab_icon")!),
            (newPostVC,
             UIImage(named: "post_tab_icon")!,
             UIImage(named: "post_tab_icon")!),
            (profileVC,
             UIImage(named: "profile_tab_icon")!,
             UIImage(named: "profile_selected_tab_icon")!),
            (activityVC,
             UIImage(named: "activity_tab_icon")!,
             UIImage(named: "activity_selected_tab_icon")!)
        ]

        let vcs = vcData.map { vc, defaultImage, selectedImage -> UINavigationController in
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem.image = defaultImage
            nav.tabBarItem.selectedImage = selectedImage
            return nav
        }

        tabController.viewControllers = vcs
        //        tabController.tabBar.isTranslucent = false

        if let items = tabController.tabBar.items {
            for item in items {
                if let image = item.image {
                    item.image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }

                if let selectedImage = item.selectedImage {
                    item.image = selectedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }

                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }

        //        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = .white

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        guard let window = appDelegate.window else { return }
        window.rootViewController = tabController
    }

    class func logout() {
        do {
            try Auth.auth().signOut()
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController

            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            guard let window = appDelegate.window else { return }
            window.rootViewController = loginVC
        } catch let error as NSError {
            print(error)
        }
    }

}
