//
//  TestDatasource.swift
//  animations
//
//  Created by Viktor Zinets on 21.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

struct DatasourceItem: Item {
    var cellReuseId: String = "StackCell"
    var data: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.cellReuseId == rhs.cellReuseId
            && lhs.data == rhs.data
    }
}

protocol DiffAbleCell {
    func configure(_ item: DatasourceItem)
}
