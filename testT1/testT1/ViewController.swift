//
//  ViewController.swift
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var gameModel: GameModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModel = GameModel()
    }

    @IBAction func onTap() {
        gameModel?.doStep()
        field.updateField(model: gameModel!)
    }

    @IBAction func onRotateTap(_ sender: AnyObject) {
        gameModel?.rotateItem()
        field.updateField(model: gameModel!)        
    }

    @IBAction func onMoveTap(_ sender: UIButton) {
        if sender.currentTitle == "<<" {
            gameModel?.moveItemLeft()
        } else if sender.currentTitle == ">>" {
            gameModel?.moveItemRight()
        }
        field.updateField(model: gameModel!) 
    }
    
    @IBOutlet weak var field: GameField!
}

