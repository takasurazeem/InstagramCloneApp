//
//  ActivityViewController.swift
//  InstagramApp
//
//  Created by Takasur A. on 26/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var segmentedControl: CustomSegmentedControl! {
        didSet {
            segmentedControl.delegate = self
        }
    }

    var currentIndex = 0

    lazy var slides: [ActivityView] = {
        let followingActivityData = FollowingActivityModel()
        let followingView = Bundle.main.loadNibNamed("ActivityView", owner: nil, options: nil)!.first as! ActivityView
        followingView.activityData = followingActivityData.followingActivity

        let youActivityData = YouActivityModel()
        let youView = Bundle.main.loadNibNamed("ActivityView", owner: nil, options: nil)!.first as! ActivityView
        youView.activityData = youActivityData.youActivity

        return [followingView, youView]
    }()

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlideScrollView(slides: slides)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setupSlideScrollView(slides: [ActivityView]) {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        for index in slides.indices {
            slides[index].frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[index])
        }
    }

}

extension ActivityViewController: ActivityDelegate {

    func scrollTo(index: Int) {
        if currentIndex == index {
            return
        }
        let pageWidth = self.scrollView.frame.width
        let slideToX = pageWidth * CGFloat(index)
        scrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: scrollView.frame.height), animated: true)
    }

}

extension ActivityViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        segmentedControl.updateSegmentedControlSegs(index: pageIndex)
        currentIndex = pageIndex
    }
}
