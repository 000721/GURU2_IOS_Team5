//
//  GalleryCard.swift
//  SchedulerSWU
//
//  Created by swuad_28 on 2021/07/30.
//

import UIKit

class GalleryCard:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension GalleryCard:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath)
        
       
        return cell
    }
    
    
}

extension GalleryCard:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat.init(362)
        let height = CGFloat.init(601)
        return CGSize(width: width, height: height)
    }
}
