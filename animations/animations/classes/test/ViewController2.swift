//
//  ViewController2.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var collectionView2: StackCardsView! {
        didSet {
            collectionView2.delegate = self
        }
    }
    enum Sections { case first }
    private lazy var dataSource: CollectionDiffAbleDatasource<Sections, StackCardItem> = {
        let ds = CollectionDiffAbleDatasource<Sections, StackCardItem>(collectionView: self.collectionView2) { [weak self] (cell, item) in
            if let cell = cell as? StackCardControl {
                cell.configure(item)
            }
        }
        return ds
    }()
    
    var users = [
        "Коля (1)",
        "Петя (2)",
        "Вася (3)",
        "Зина (4)",
        "Люся (5)",
    ]
    
    var podliva = [
        "user 1",
        "user 2",
        "user 3",
        "user 4",
        "user 5",
        "user 6",
        "user 7",
    ]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateStack()
    }
    
    func updateStack(_ animated: Bool = false) {
        self.dataSource.beginUpdates()
        
        self.dataSource.appendSections([.first])
        let items = users.map { StackCardItem(data: $0) }
        self.dataSource.appendItems(items, toSection: .first)
        
        self.dataSource.endUpdates(animated)
    }
    
    @IBAction func removeTop(_ sender: Any) {
        users.remove(at: 0)
        self.updateStack(true)
        if users.count < 3 && !podliva.isEmpty {
            users += podliva
            self.updateStack(true)
        }
        
    }
    
    @IBAction func resotreStack(_ sender: Any) {
        users = []
        self.updateStack(false)
        
        users = [
            "Коля (1)",
            "Петя (2)",
            "Вася (3)",
            "Зина (4)",
            "Люся (5)",
        ]
        podliva = [
            "user 1",
            "user 2",
            "user 3",
            "user 4",
            "user 5",
            "user 6",
            "user 7",
        ]
        self.updateStack(true)
    }
    
    @IBAction func insertTop(_ sender: Any) {
        users.insert("Дуня !", at: 0)
        self.updateStack(true)
    }
    
    
    
}

extension ViewController2: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? StackCell {
            cell.swipeDelegate = self
            cell.actionDelegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension ViewController2: SwipeableDelegate, LikeBookCellDelegate {
    
    func didSomeAction() {
        print(#function)
    }    
    
    func didBeginSwipe(view: UIView) {
        
    }
    
    func didChangeSwipeProgress(view: UIView, progress: CGFloat) {
        print(progress)
        if let view = view as? OverlayedView {
            view.overlayOpacity = abs(progress)
        }
    }
    
    func didEndSwipe(view: UIView, direction: SwipeDirection) {
        print(direction)
        self.collectionView2.removingDirection = direction
        self.removeTop(self)
    }
    
    func didCancelSwipe(view: UIView) {
        
    }
    
    
}
