//
//  TapplRequestsListDatasource.swift
//  testEndlessScroll
//
//  Created by Victor Zinets on 1/18/19.
//  Copyright © 2019 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class TapplRequestsListDatasourceItem: DataSourceItem {
    var screenName: String = ""
    var imageName: String = ""
    var heartName: String = ""
}

class TapplRequestsListDatasource: CollectionSectionDatasource {
    
    override var supportedCellTypes: [CellType] {
        return [
            "TapplRequestCellId",
            "TapplRequestPlaceholderId"
        ]
    }
    
    var onDataUpdated: ((Int) -> Void)?
    override var items: [DataSourceItem] {
        didSet {
            if let onDataUpdated = self.onDataUpdated {
                onDataUpdated(items.count)
            }
        }
    }
}
