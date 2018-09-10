//
//  SectionDatasource.swift
//

import UIKit

class SectionDatasource: NSObject {
    var cellsFactory: CellsFactory!    
    
    var internalItems = [DataSourceItem]()
    var supportedCellTypes: [CellType] {
        get {
            return []
        }
    }
    
    init(_ factory: CellsFactory) {
        super.init()
        self.cellsFactory = factory
    }
    
    var toRemove = Set<Int>()
    var toInsert = Set<Int>()
    var toUpdate = Set<Int>()
    
    var items:[DataSourceItem] {
        get {
            return internalItems;
        }
        set {
            let countChanged = calculateChangesFrom(fromArray: internalItems, toArray: newValue)
            internalItems = newValue
            
            if let handler = onNumberOfItemsChanged, countChanged {
                handler()
            }
        }
    }
    
    var onNumberOfItemsChanged: (() -> ())?
    
    func objectsEqual(obj1: AnyHashable, obj2: AnyHashable) -> Bool {
        return obj1 == obj2
    }
    
    func calculateChangesFrom(fromArray: [AnyHashable], toArray: [AnyHashable]) -> Bool {
        var result = false;
        
        toRemove.removeAll()
        toInsert.removeAll()
        toUpdate.removeAll()
        
        if ((fromArray.count == 0 && toArray.count == 0) || fromArray == toArray) {
            return result
        } else if (fromArray.count == 0 && toArray.count > 0) {
            // insert all
            for index in 0..<toArray.count {
                toInsert.insert(index)
            }
            
            return true
        } else if (fromArray.count > 0 && toArray.count == 0) {
            // remove all
            for index in 0..<fromArray.count {
                toRemove.insert(index)
            }
            return true
        }
        
        var temp = [[Int]](repeating: [Int](repeating: 0, count: toArray.count + 1), count: fromArray.count + 1)
        for index in 0..<toArray.count {
            temp[0][index] = index
        }
        for index in 0..<fromArray.count {
            temp[index][0] = index
        }
        for i in 1...fromArray.count {
            for j in 1...toArray.count {
                if (fromArray[i - 1] == toArray[j - 1]) {
                    temp[i][j] = temp[i - 1][j - 1];
                } else {
                    temp[i][j] = 1 + min(temp[i - 1][j - 1], temp[i - 1][j], temp[i][j - 1]);
                }
            }
        }
        
        //    for (NSUInteger i = 0; i <= fromArray.count; i++) {
        //        NSString *string = @"";
        //        for (NSUInteger j = 0; j <= toArray.count; j++) {
        //            string = [string stringByAppendingFormat:@"%@ ", @(temp[i][j])];
        //        }
        //        NSLog(string);
        //    }
        
        var i = fromArray.count
        var j = toArray.count
        while true {
            if (i == 0 && j == 0) {
                break
            }
            
            if (i > 0 && j > 0 && fromArray[i - 1] == toArray[j - 1]) {
                i = i - 1;
                j = j - 1;
            } else if (i > 0 && j > 0 && temp[i][j] == temp[i - 1][j - 1] + 1){
//                print("replace \(fromArray[i - 1]) with \(toArray[j - 1])")
                toUpdate.insert(i - 1);
                i = i - 1;
                j = j - 1;
            } else if (i > 0 && temp[i][j] == temp[i - 1][j] + 1) {
//                print("delete \(fromArray[i - 1]) @ index \((i - 1))")
                result = true
                toRemove.insert(i - 1);
                i = i - 1;
            } else if (j > 0 && temp[i][j] == temp[i][j - 1] + 1){
//                print("Insert \(toArray[j - 1]) @ index \((j - 1))")
                result = true
                toInsert.insert(j - 1);
                j = j - 1;
            } else {
                print("WTF?");
            }
        }
        
        return result
    }
    
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
