//
//  GalleryViewController+FlowLayout.swift
//  ProjectOneGB
//
//  Created by Василий Метлин on 20.10.2021.
//

import UIKit

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let whiteSpace = CGFloat(5)
        let lineCountCell = CGFloat(2)
        let cellWidth = collectionViewWidth / lineCountCell - whiteSpace
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
