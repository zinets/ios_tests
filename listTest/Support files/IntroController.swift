//
//  IntroController.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class IntroController: UIViewController {
    
    @IBOutlet weak var introView: IntroView!
    let datasource = IntroViewDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var array = [DataSourceItem]()
        array.append(DataSourceItem(CellType.TestIntroFirst))
        array.append(DataSourceItem(CellType.TestIntroOther, payload: "onboardingIllustration1"))
        array.append(DataSourceItem(CellType.TestIntroOther, payload: "onboardingIllustration2"))
        array.append(DataSourceItem(CellType.TestIntroOther, payload: "onboardingIllustration3"))
        datasource.items = array
        introView.dataSource = datasource
    }



}
