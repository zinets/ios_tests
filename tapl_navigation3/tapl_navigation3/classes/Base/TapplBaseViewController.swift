//
//  TapplBaseViewController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    // призрак предыдущего контроллера
    var shadowedView: UIView? {
        willSet {
            if let view = shadowedView {
                view.removeFromSuperview()
            }
        }
    }
    
    // место таскания для возврата на пред. контроллер
    private var handleView: UIView!
    var isHandleViewVisible: Bool = false {
        didSet {
            handleView.isHidden = !isHandleViewVisible
        }
    }
    
    // тень вокруг окна, нужна только для "корневого" контроллера
    var shadowIsVisible: Bool = false {
        didSet {
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.duration = 0.15
            if self.shadowIsVisible {
                self.view.layer.shadowOpacity = 0.6
                self.view.clipsToBounds = false
            } else {
                self.view.layer.shadowOpacity = 0.0
                self.view.clipsToBounds = true
            }
            self.view.layer.add(animation, forKey: "shadow")
        }
    }
    
    private func setupAppearance() {
        self.view.layer.cornerRadius = TapplMagic.viewControllerCornerRadius
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // iOS11+
        
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.0
        self.view.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.view.layer.shadowColor = TapplMagic.controllerShadowColor.cgColor
        
        self.addHandle()
    }
    
    private func addHandle () {
        handleView = UIView()
        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.backgroundColor = UIColor.clear
        handleView.isHidden = true
        
        self.view.addSubview(handleView)
        // модно, стильно, молодежно!
        NSLayoutConstraint.activate([
            handleView.widthAnchor.constraint(equalToConstant: 300),
            handleView.heightAnchor.constraint(equalToConstant: TapplMagic.viewControllerCornerRadius),
            handleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            handleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            ])
        
        let grayView = UIView()
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        grayView.layer.cornerRadius = 2
        
        handleView.addSubview(grayView)
        NSLayoutConstraint.activate([
            grayView.widthAnchor.constraint(equalToConstant: 46),
            grayView.heightAnchor.constraint(equalToConstant: 4),
            grayView.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            grayView.centerYAnchor.constraint(equalTo: handleView.centerYAnchor),
            ])
    }
    
    var handleForBackGesture: UIView? {
        return self.handleView
    }
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private func setupRecognizing() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        self.handleView.addGestureRecognizer(panRecognizer)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        self.setupRecognizing()
        
        self.shadowIsVisible = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.delegate = self
    }
    
    @IBAction func backAction(_ sender: Any) {
       myCtrl.popController(self)
    }
    
    // test push
    @IBAction func push(_ sender: Any) {
        if let ctrl = UIStoryboard(name: "TapplSearch", bundle: nil).instantiateViewController(withIdentifier: "WhiteCtrl") as? TapplBaseViewController {
            myCtrl.pushController(ctrl, navController: self.navigationController!)
        }
    }
    
    
}

extension TapplBaseViewController: UINavigationControllerDelegate {
    
    @objc private func handleBackGesture(_ gesture : UIPanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.y / self.view.frame.height

        switch gesture.state {
        case .began:
            if let navCtrl = self.navigationController {
                self.interactionController = UIPercentDrivenInteractiveTransition()
                navCtrl.popViewController(animated: true)
                myCtrl.isNavbarVisible = self.navigationController?.viewControllers.count == 1
                //            myCtrl.popController(self)
            }
            break
        case .changed:
            self.interactionController?.update(progress)
            break
        case .cancelled, .ended:
            let velocity = gesture.velocity(in: gesture.view)
            
            if progress > 0.5 || velocity.y > 0 || gesture.state == .cancelled {
                self.interactionController?.finish()
            } else {
                self.interactionController?.cancel()
                myCtrl.isNavbarVisible = false
            }
            self.interactionController = nil
            
            break
        default:
            return
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return self.interactionController
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return TapplPushAnimator()
        case .pop:
            return TapplPopAnimator()
        default:
            return nil
        }
    }
    
}
