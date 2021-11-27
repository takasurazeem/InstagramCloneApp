//
//  StoriesTableViewCell.swift
//  InstagramApp
//
//  Created by Takasur A. on 27/11/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class StoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var stories: [Story] = {
        
        let model = Model()
        
        return model.storyList
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        collectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoryCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
    
}

extension StoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: 90, height: 90)
        
    }
    
}
