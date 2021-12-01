//
//  CameraViewController.swift
//  InstagramApp
//
//  Created by Takasur A. on 28/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    @IBOutlet var simpleCameraView: SimpleCameraView!
    var simpleCamera: SimpleCamera!

    override func viewDidLoad() {
        super.viewDidLoad()
        simpleCamera = SimpleCamera(cameraView: simpleCameraView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        simpleCamera.startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        simpleCamera.stopSession()
    }

    @IBAction func startCapture(_: UIButton) {
        if simpleCamera.currentCaptureMode == .photo {
            simpleCamera.takePhoto { imageData, success in
                if success {
                    print("image success")
                }
                if imageData != nil {
                    print("Image data exists.")
                }
            }
        }
    }
}
