//
//  ViewController.swift
//  testObserving
//
//  Created by Victor Zinets on 11/1/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
   
    var dataSource = [ObjClassModel]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        for section in 0...3 {
            let sectionName = "Section " + String(section)
            let obj = ObjClass()
            obj.caption = sectionName
            for item in 0...4 {
                obj.addMessage(String(sectionName) + ", item: " + String(item))
            }
            
            dataSource.append(ObjClassModel(with: obj))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].numberOfMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            let text = dataSource[indexPath.section].message(forIndex: indexPath.item)
            cell.label.text = text
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: actions -
    
    @IBAction func reloadtable(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func addRandom(_ sender: Any) {
        let sectionObject = dataSource.randomElement()
        sectionObject!.addRandomElement()
    }
    
}

