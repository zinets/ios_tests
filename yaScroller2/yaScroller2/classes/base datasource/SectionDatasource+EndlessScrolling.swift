//
//  SectionDatasource+EndlessScrolling.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

extension SectionDatasource {
    
    // MARK: endless scrolling -
    
    // бесконечная прокрутка реализована как перестановка элементов первого -> последний и наоборот + отключение "автоанимации"
    // но инициатором должен быть кто-то, кто будет следить за прокруткой или просто по таймеру говорить "дальше!"
    
    func shiftDataPrev()  {
        var data = items
        if let firstObject = data.first {
            data.removeFirst()
            data.append(firstObject)
            
            UIView.setAnimationsEnabled(false)
            items = data
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func shiftDataNext() {
        var data = items
        if let lastObject = data.last {
            data.removeLast()
            data.insert(lastObject, at: 0)
            
            UIView.setAnimationsEnabled(false)
            items = data
            UIView.setAnimationsEnabled(true)
        }
    }    
}
