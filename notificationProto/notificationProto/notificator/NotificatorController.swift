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
    private var isHeaderVisible = false
    private var isFooterVisible = false
    
    @IBOutlet weak var tableView: UITableView!
    private var datasource: TableDiffAbleDatasource<Sections, NotificationItem>!
    
    private func prepareDatasource() {
        self.datasource = TableDiffAbleDatasource(tableView: self.tableView, cellConfigurator: { (cell, item) in
            if let cell = cell as? NotificatorGroupedCell {
                cell.fillData(item)
            }
        })
        
        self.tableView.register(UINib(nibName: "NotificatorHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        self.tableView.register(UINib(nibName: "NotificatorFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
        
        // test data
        self.datasource.beginUpdates()

        let item = NotificationItem(with: "NotificatorGroupedCell")
        item.notificationText = "Danielle liked your photo и послала тебе фото своей киски"
        item.notificationAge = "2 days ago"
        item.notificationType = .visitor
        
        self.datasource.appendSections([.main])
        self.datasource.appendItems([item], toSection: .main)
        
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
    
    var numberOfItems: Int = 5 {
        didSet {
            self.datasource.beginUpdates()
            
            self.datasource.appendSections([.main])
            
            var items: [NotificationItem] = []
            for x in 1..<numberOfItems {
                items.append(NotificationItem(with: "NotificatorSingleCell"))
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
            let bgColor = !compactMode ? UIColor.black.withAlphaComponent(0.3) : .clear
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = bgColor
            }) { (_) in
//                self.isFooterVisible = !self.compactMode
                self.isHeaderVisible = !self.compactMode
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            
            
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
        case .began:
            let pt = sender.velocity(in: sender.view)
            isDirectionVertical = abs(pt.y) > abs(pt.x)
        case .changed:
            let pt = sender.translation(in: sender.view)
            if isDirectionVertical! {
                self.view.transform = CGAffineTransform(translationX: 0, y: min(0, pt.y))
            } else {
                self.view.transform = CGAffineTransform(translationX: pt.x, y: 0)
            }
        case .ended:
            let pt = sender.translation(in: sender.view)
            var translation: CGFloat
            var velocity: CGFloat
            
            let maxVelocity: CGFloat = 2134
            let maxX = self.view.bounds.width / 3
            let maxY: CGFloat = 67.0 
            
            var shouldFinish: Bool
            if isDirectionVertical! {
                translation = abs(pt.y)
                velocity = abs(sender.velocity(in: sender.view).y)
                shouldFinish = translation > maxY || velocity > maxVelocity
            } else {
                translation = abs(pt.x)
                velocity = abs(sender.velocity(in: sender.view).x)
                shouldFinish = translation > maxX || velocity > maxVelocity
            }
            
            isDirectionVertical = nil
            
            UIView.animate(withDuration: 0.1, animations: {
                if shouldFinish {
                    self.view.alpha = 0
                } else {
                    self.view.transform = .identity
                }
            }) { (_) in
                if shouldFinish {
                    self.closeAction(self)
                }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isHeaderVisible ? UITableView.automaticDimension : 0
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isFooterVisible ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")
        return footer
    }
   
}
