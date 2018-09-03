//
//  PhotoScroller
//

import UIKit

// скроллер фото, фото на весь фрейм
class PhotoScroller: UIView, UICollectionViewDelegate {
    
    
    var dataSource: CollectionSectionDatasource? {
        didSet {
            dataSource?.collectionView = self.collectionView
        }
    }    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(collectionView)
    }
    
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        layout.itemSize = bounds.size
        
        var _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        _collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _collectionView.backgroundColor = UIColor.white
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        _collectionView.delegate = self
        
        
        return _collectionView
    }()

}
