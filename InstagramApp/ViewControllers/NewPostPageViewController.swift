//
//  NewPostPageViewController.swift
//  InstagramApp
//
//  Created by Takasur A. on 28/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class NewPostPageViewController: UIPageViewController, UIPageViewControllerDelegate {

    var orderedViewControllers: [UIViewController] = []
    var currentIndex: Int = 0
    var pagesToShow = NewPostPagesToShow.pagesToShow()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self

        for pageToShow in pagesToShow {
            let pageToShow = newViewController(pageToShow: pageToShow)
            orderedViewControllers.append(pageToShow)
        }
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(NewPostPageViewController.newPage(notification:)), name: NSNotification.Name.init(rawValue: "newPage"), object: nil)
    }

    private func newViewController(pageToShow: NewPostPagesToShow) -> UIViewController {
        let storyboard = UIStoryboard(name: "NewPost", bundle: nil)
        switch pageToShow {
        case .library:
            return storyboard.instantiateViewController(withIdentifier: pageToShow.identifier) as! PhotoLibraryViewController
        case .camera:
            return storyboard.instantiateViewController(withIdentifier: pageToShow.identifier) as! CameraViewController
        }
    }

    @objc func newPage(notification: NSNotification) {
        if let receivedObject = notification.object as? NewPostPagesToShow {
            showViewController(index: receivedObject.rawValue)
        }
    }

    private func showViewController(index: Int) {
        if currentIndex > index {
            setViewControllers([orderedViewControllers[index]], direction: .reverse, animated: true, completion: nil)
        } else if currentIndex < index {
            setViewControllers([orderedViewControllers[index]], direction: .forward, animated: true, completion: nil)
        }
        currentIndex = index
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "newPage"), object: nil)
    }
}

extension NewPostPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllerCount: Int = orderedViewControllers.count
        guard nextIndex != orderedViewControllerCount else {
            return nil
        }
        guard orderedViewControllerCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }

}
