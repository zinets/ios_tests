//
//  ViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class ViewController: TapplBaseViewController, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        return cell
    }


}

