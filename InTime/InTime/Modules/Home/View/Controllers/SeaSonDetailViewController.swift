//
//  SeaSonDetailViewController.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class SeaSonDetailViewController: BaseViewController {
    
    var season: SeasonModel = SeasonModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = season.title
        view.backgroundColor = UIColor.tintColor
    }

}
