//
//  CustomSegmentedControl.swift
//  InstagramApp
//
//  Created by Takasur A. on 01/12/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

protocol ActivityDelegate: AnyObject {
    func scrollTo(index: Int)
}

class CustomSegmentedControl: UIView {
    var buttons: [UIButton] = []
    var selector: UIView!
    var selectedSegmentIndex: Int = 0
    let buttonTitles = ["Following", "You"]
    let textColour: UIColor = .lightGray
    let selectorColour: UIColor = .black
    let selectorTextColor: UIColor = .black

    weak var delegate: ActivityDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }

    func updateView() {
        // remove any buttons if already there
        buttons.removeAll()
        // remove all subviews (StackView) too
        subviews.forEach { $0.removeFromSuperview() }
        // iterate over button titles and
        // append buttons with those titles
        // to the buttons array.
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            // TODO: - Implement later
            //            button.addTarget(self, action: #selector(), for: .touchUpInside)
            buttons.append(button)
        }
        // set the title color for first and default selected button
        buttons.first?.setTitleColor(selectorTextColor, for: .normal)

        // dynamically calculate width
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        // dynamically y position
        let yPos = (self.frame.maxY - self.frame.minY) - 2.0
        // create the selector itself
        selector = UIView(frame: CGRect(x: 0, y: yPos, width: selectorWidth, height: 2))
        selector.backgroundColor = selectorColour
        // add selector to subview
        addSubview(selector)
    }

}
