//
//  CollectionSectionDatasource.swift
//

import UIKit

open class CollectionSectionDatasource : SectionDatasource, UICollectionViewDataSource {
    var section: Int = 0
    public var collectionView: UICollectionView? {
        didSet {
            if let collection = collectionView {
                collection.dataSource = self
                
                for cellType in supportedCellTypes {
                    let cellId = self.cellIdFor(cellType)
                    if let cellNib = self.cellNibFor(cellType) {
                        collection.register(UINib(nibName: cellNib, bundle: nil), forCellWithReuseIdentifier: cellId)
                    }
                }
            }
        }
    }
    
    // MARK: overrides -
    
    override open var items:[DataSourceItem] {
        // очень хочется думать, что это поможет пофикисть странные ошибки, когда данные присваиваются в пустой датасорс и тут же все падает с как обычно "вставка 3 записи, было 3, должно быть 3, бла-бла"; как так получается, что делается присваивание массива с вычислением разницы, а потом вдруг данные уже есть? если делается раскладка в интерфейсе, то в performBatch... внутри где-то запрашиваются ячейки (или как минимум numberOfItemsAt.. для вычисления высоты сожет и -> датасорс перед вставкой/удалением элементов уже "знает" другие значения)
        // но если перед вставкой обновить раскладку, то есть хорошие шансы, что такого не будет
        willSet {
            if let collection = collectionView {
                collection.layoutIfNeeded()
            }
        }
        didSet {
            if let collection = collectionView {
                collection.performBatchUpdates({
                    if (toRemove.count > 0) {
                        var array = [IndexPath]()
                        for index in toRemove {
                            array.append(IndexPath(item: index, section: section))
                        }
                        collection.deleteItems(at: array)
                    }
                    if (!toInsert.isEmpty) {
                        var array = [IndexPath]()
                        for index in toInsert {
                            array.append(IndexPath(item: index, section: section))
                        }
                        collection.insertItems(at: array)
                    }
                    if (!toUpdate.isEmpty) {
                        var array = [IndexPath]()
                        for item in toUpdate {
                            array.append(IndexPath(item: item, section: section))
                        }
                        collection.reloadItems(at: array)
                    }
                }) { (finished) in
                    
                }
            }
        }
    }
    
    // MARK: collection support -
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = items[indexPath.item]
        let cellId = cellIdFor(data.itemType)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? DataAwareCell {
            cell.fillWithData(data)            
            return cell as! UICollectionViewCell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
}
