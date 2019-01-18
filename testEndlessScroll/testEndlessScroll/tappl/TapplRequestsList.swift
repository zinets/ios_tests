//
//  TapplRequestsList.swift
//  testEndlessScroll
//
//  Created by Victor Zinets on 1/17/19.
//  Copyright © 2019 Victor Zinets. All rights reserved.
//

import UIKit

class TapplRequestsList: UICollectionView {

    private var cellWidth: CGFloat {
        get {
            var w: CGFloat = 68
            if let mode = viewMode {
                if mode == .placeholder {
                    w = self.bounds.size.width
                }
            }
            return w
        }
    }
    private let cellSpacing: CGFloat = 14
    
    private let internalDataSource = TapplRequestsListDatasource()
    private let placeholderDataSource: TapplRequestsListDatasource = {
        let dataSource = TapplRequestsListDatasource()
        let onlyItem = TapplRequestsListDatasourceItem("TapplRequestPlaceholderId", payload: nil)
        dataSource.items = [onlyItem]
        return dataSource
    }()
    
    enum ViewMode {
        case normal
        case placeholder
    }
    
    var data: [TapplRequestsListDatasourceItem] {
        set {
            internalDataSource.items = newValue
        }
        get {
            return internalDataSource.items as! [TapplRequestsListDatasourceItem]
        }
    }
    
    var viewMode: ViewMode? {
        didSet {
            guard viewMode != nil, viewMode != oldValue else { return }
            switch viewMode! {
            case .normal:
                placeholderDataSource.collectionView = nil
                internalDataSource.collectionView = self
                
                self.selectedIndex = 0
            case .placeholder:
                internalDataSource.collectionView = nil
                placeholderDataSource.collectionView = self
                
                self.reloadData()
                self.selectedIndex = nil
            }
        }
    }
    
    func removeSelected() {
        guard let index = self.selectedIndex else { return }
        
        self.data.remove(at: index)
        let maxIndex = self.data.count - 1
        
        if maxIndex < 0 {
            selectedIndex = nil
        } else {
            selectedIndex = min(index, maxIndex)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        
        internalDataSource.onDataUpdated = { (newCount: Int) in
            self.viewMode = newCount == 0 ? .placeholder : .normal
        }
        
        self.isScrollEnabled = false
        
        var swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLeftAction(_:)))
        swipeRecognizer.direction = .left
        self.addGestureRecognizer(swipeRecognizer)
        
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRightAction(_:)))
        swipeRecognizer.direction = .right
        self.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc private func swipeToLeftAction(_ sender: UISwipeGestureRecognizer) {
        guard let index = self.selectedIndex else { return }
        self.selectedIndex = index + 1
    }
    @objc private func swipeToRightAction(_ sender: UISwipeGestureRecognizer) {
        guard let index = self.selectedIndex else { return }
        self.selectedIndex = index - 1
    }
    
    var selectedIndex: Int? = 0 {
        didSet {
            guard let index = selectedIndex else {
                return
            }
            let maxCount = internalDataSource.items.count - 1
            selectedIndex = max(0, min(index, maxCount))
            
            let offset = CGFloat(selectedIndex!) * (cellWidth + cellSpacing)
            self.setContentOffset(CGPoint(x: offset, y: 0), animated: true)            
        }
    }
}

extension TapplRequestsList: UICollectionViewDelegateFlowLayout {
       
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let tappleRequestCell = cell as? TapplRequestsListCell {
            tappleRequestCell.centerPos = self.cellPos(cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let mode = viewMode, mode == .normal {
            self.selectedIndex = indexPath.item
        }
    }
    
    // MARK: - appearance
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offset = (collectionView.bounds.size.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
       
    // MARK: - scrolling
    
    private func cellPos(_ cell: UICollectionViewCell) -> CGFloat {
        let halfWidth = self.bounds.size.width / 2
        let quaterWidth = halfWidth / 2
        let x = cell.center.x - self.contentOffset.x
        return (x - halfWidth) / quaterWidth
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for cell in self.visibleCells {
            if let c = cell as? TapplRequestsListCell {
                c.centerPos = self.cellPos(cell)
            }
        }
        
    }
}
