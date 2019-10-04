//
//  NotificatorController.swift
//  test1
//
//  Created by Viktor Zinets on 10/1/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

// допустим это будет универсальный контроллер для показа нотификаций; предполагается, что любому дизайну хватит таблицы (?) - значит тут можно оставить работу с таблицей, создаваться будет контроллер из сториборда, в котором а) конкретный дизайн б) привязка к конкретному классу - наследнику от этого класса, в котором сделается настройка дизайна
class NotificatorController: UIViewController {
    
    enum Sections {
        case main
    }
    var isHeaderVisible = false
    var isFooterVisible = false
    
    @IBOutlet weak var tableView: UITableView!
    public private(set) var datasource: TableDiffAbleDatasource<Sections, NotificationItem>!
    
    func prepareDatasource() {
        self.datasource = TableDiffAbleDatasource(tableView: self.tableView, cellConfigurator: { (cell, item) in
            // TODO: сделать базовый метод заполнения ячейки cell данными из item? и в конкретном наследнике перегружать собственно полезной работой?
            if let cell = cell as? MDUKNotificatorGroupedCell {
                cell.fillData(item)
//            } else if let cell = cell as? NotificatorSingleCell {
//                cell.fillData(item)
            }
        })       
        
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
            
//            self.compactMode = false
        }
    }
    
    
    
    // MARK: gestures -
    
    var panRecognizer: UIPanGestureRecognizer?
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

extension NotificatorController {
    
    func attributedStringForText(text: String, selected: [String]) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
        ]
        for str in selected {
            let range = NSRange(text.range(of: str)!, in: text)
            attributedString.addAttributes(selectedAttributes, range: range)
        }
        
        return attributedString
    }
    
}
