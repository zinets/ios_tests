//
//  NotificatorController.swift
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
        self.datasource = TableDiffAbleDatasource(tableView: self.tableView, cellConfigurator: { [weak self] (cell, item) in
            self?.prepareCell(cell, item)
        })
        
//        self.datasource = TableDiffAbleDatasource(tableView: self.tableView, cellConfigurator: self.prepareCell(_:_:))
    }
    
    func prepareCell(_ cell: UITableViewCell, _ item: NotificationItem) {
        fatalError()
    }
    
    // MARK: life blah-blah-blah.. -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareDatasource()
        self.prepareRecognizers()
    }
    
    deinit {
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: actions -
    @IBAction func closeAction(_ animated: Bool = false) {
        
        removeTimer?.invalidate()
        
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            self.view.alpha = 0
        }) { (_) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()

            self.removeFromParent()
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
            // вот загадка: вертикальное движение начинает отслеживаться только с "группированной" ячейкой, но не с одинарной
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
                    self.closeAction(false)
                }
            }
            
        default:
            break
        }
    }
    
    // MARK: payload -
    var notifications: [NotificationData]!
    
    // MARK: autoremove -
    var removeTimer: Timer?
    
    @objc func removeTimerFired(sender: Timer) {
        self.closeAction(true)
    }
    
    func startTimer() {
        removeTimer?.invalidate()
        
        let timerPeriod: TimeInterval = 5
        removeTimer = Timer.scheduledTimer(timeInterval: timerPeriod, target: self, selector: #selector(removeTimerFired(sender:)), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        removeTimer?.invalidate()
    }
}

extension NotificatorController: UITableViewDelegate {

    // TODO: remove
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return isHeaderVisible ? UITableView.automaticDimension : 0
//    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        return header
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return isFooterVisible ? UITableView.automaticDimension : 0
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")
        return footer
    }
   
}


extension NotificatorController {
    
    // TODO: вроде это относится к дизайну..
    func attributedStringWithBoldSelection(text: String, selected: [String]) -> NSAttributedString {
        
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
