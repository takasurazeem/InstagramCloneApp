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
            // add selector
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
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

        // Create stack view with buttons
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    @objc func buttonTapped(button: UIButton) {
        for (buttonIndex, enumeratedButton) in buttons.enumerated() {
            enumeratedButton.setTitleColor(textColour, for: .normal)
            if enumeratedButton == button {
                selectedSegmentIndex = buttonIndex
                delegate?.scrollTo(index: selectedSegmentIndex)
            }
        }
    }

    func updateSegmentedControlSegs(index: Int) {
        for button in buttons {
            button.setTitleColor(textColour, for: .normal)
        }
        let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(index)
        UIView.animate(withDuration: 0.3) {
            self.selector.frame.origin.x = selectorStartPosition
        }
        buttons[index].setTitleColor(selectorTextColor, for: .normal)
    }
}
