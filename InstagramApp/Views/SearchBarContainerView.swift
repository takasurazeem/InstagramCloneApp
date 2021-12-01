//
//  SearchBarContainerView.swift
//  InstagramApp
//
//  Created by Takasur A. on 27/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class SearchBarContainerView: UIView {
    let searchBar: UISearchBar

    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
    }

    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        searchBar.frame = bounds
    }
}
