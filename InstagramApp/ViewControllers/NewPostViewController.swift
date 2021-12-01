//
//  NewPostViewController.swift
//  InstagramApp
//
//  Created by Takasur A. on 26/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

enum NewPostPagesToShow: Int {
    case library, camera

    var identifier: String {
        switch self {
        case .library:
            return "PhotoLibraryViewController"
        case .camera:
            return "CameraViewController"
        }
    }

    static func pagesToShow() -> [NewPostPagesToShow] {
        return [.library, .camera]
    }
}

class NewPostViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func libraryButtonDidTouch(_: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("newPage"), object: NewPostPagesToShow.library)
    }

    @IBAction func photoButtonDidTouch(_: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("newPage"), object: NewPostPagesToShow.camera)
    }
}
