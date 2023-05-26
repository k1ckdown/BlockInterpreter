//
//  FilePreviewLayout.swift
//  BlockInterpreter
//
import UIKit

final class FilePreviewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
        
        sectionInset.left = 15
        sectionInset.right = sectionInset.left
        
        let itemInRow: CGFloat = 2
        let sideInset = sectionInset.left + sectionInset.right
        let lineInset = sideInset + minimumInteritemSpacing * (itemInRow - 1)
        let avaiableSpace = collectionView.frame.width - lineInset
        
        let cellWidth = avaiableSpace / itemInRow
        itemSize = CGSize(width: cellWidth, height: cellWidth * 1.4)
        
    }

}
