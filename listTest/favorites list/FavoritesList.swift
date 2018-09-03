//
//  FavoritesList.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

// скроллер гипотетических друзей, списочек
class FavoritesList: UIView, UITableViewDelegate {
    
    var dataSource: TableSectionDatasource? {
        didSet {
            dataSource?.tableView = self.tableView
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
        addSubview(tableView)
    }
    
    private lazy var tableView: UITableView = {
        var _tableView = UITableView(frame: bounds, style: .plain)
        _tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _tableView.backgroundColor = UIColor.white
        _tableView.decelerationRate = UIScrollViewDecelerationRateFast
        _tableView.rowHeight = 80
        _tableView.delegate = self
        
        return _tableView
    }()
}
