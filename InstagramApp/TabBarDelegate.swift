//
//  TabBarDelegate.swift
//  InstagramApp
//
//  Created by Takasur A. on 28/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import Foundation
import UIKit

class TabBarDelegate: NSObject, UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect viewController: UIViewController) {
        let navigationController = viewController as? UINavigationController
        _ = navigationController?.popViewController(animated: false)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedViewContoller = tabBarController.selectedViewController else { return false }

        if viewController == selectedViewContoller {
            return false
        }

        guard let controllerIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else { return true }

        if controllerIndex == 2 {
            let newPostStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
            let newPostVC = newPostStoryboard.instantiateViewController(withIdentifier: "NewPost") as! NewPostViewController

            let navController = UINavigationController(rootViewController: newPostVC)
            navController.modalPresentationStyle = .fullScreen
            selectedViewContoller.present(navController, animated: true, completion: nil)

            return false
        }

        let navigationController = viewController as? UINavigationController
        _ = navigationController?.popViewController(animated: false)
        return true
    }
}
