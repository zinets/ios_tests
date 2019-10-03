//
//  NotificatorController.swift
//  test1
//
//  Created by Viktor Zinets on 10/1/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class NotificatorController: UIViewController {
    
    enum Sections {
        case main
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var datasource: TableDiffAbleDatasource<Sections, TableItem>!
    
    private func prepareDatasource() {
        self.datasource = TableDiffAbleDatasource(tableView: self.tableView, cellConfigurator: { (cell, item) in
//            cell.textLabel?.text = item.modelData
        })
//        self.datasource.onEmptyDataset = { newState in
//            print("placeholder state:\(newState ? "visible" : "hidden")")
//        }
        
        self.tableView.register(UINib(nibName: "NotificatorHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        self.tableView.register(UINib(nibName: "NotificatorFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
        
        // test data
        self.datasource.beginUpdates()
        
        self.datasource.appendSections([.main])
        let items = ["purpleCell", "purpleCell"].map { (cellId) -> TableItem in
            let item = TableItem(with: cellId)
            return item
        }
        self.datasource.appendItems(items, toSection: .main)
        
        self.datasource.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareDatasource()
        self.prepareRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func closeAction(_ sender: Any) {
        
        self.view.removeFromSuperview()
        
    }
        
    @IBAction func addItem(_ sender: Any) {
        numberOfItems += 1
    }
    
    var numberOfItems: Int = 2 {
        didSet {
            self.datasource.beginUpdates()
            
            self.datasource.appendSections([.main])
            
            var items = [TableItem(with: "orangeCell"), TableItem(with: "purpleCell")]
            for x in 1..<numberOfItems {
                let item = TableItem(with: "orangeCell")
                item.index = x
                items.append(item)
            }
            self.datasource.appendItems(items, toSection: .main)
            
            self.datasource.endUpdates()
            
            compactMode = false
        }
    }
    
    // MARK: appearance -
    let compactHeight: CGFloat = 150
    var compactMode: Bool = true {
        didSet {
            guard oldValue != compactMode else {
                return
            }
            var frame = self.view.frame
            if compactMode {
                frame.size.height = compactHeight
            } else {
                frame.size.height = self.view.superview!.bounds.size.height
            }
            self.view.frame = frame
            
            panRecognizer?.isEnabled = compactMode
        }
    }
    
    // MARK: gestures -
    
    private var panRecognizer: UIPanGestureRecognizer?
    private func prepareRecognizers() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(sender:)))
        self.view.addGestureRecognizer(panRecognizer!)
    }
    
    private var isDirectionVertical: Bool?
    @objc func onPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let pt = sender.translation(in: self.view)
            if isDirectionVertical == nil {
                isDirectionVertical = abs(pt.y) > abs(pt.x)
            }
            if isDirectionVertical! {
                self.view.transform = CGAffineTransform(translationX: 0, y: pt.y)
            } else {
                self.view.transform = CGAffineTransform(translationX: pt.x, y: 0)
            }
        case .ended:
            isDirectionVertical = nil
            UIView.animate(withDuration: 0.1) {
                self.view.transform = .identity
            }
        default:
            break
        }
    }
    
}

extension NotificatorController: UITableViewDelegate {

    // TODO: remove
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.numberOfItems += 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")
        return footer
    }
   
}
