//
//  File.swift
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2021/1/13.
//  Copyright © 2021 jiasong. All rights reserved.
//

import Foundation
import JSLayoutSizeFit

class zzcell: UITableViewCell {
    
}

class zz: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tablView = UITableView()
        tablView.lsf.fittingHeight(forCellClass: UITableViewCell.self) { (cell: zzcell) in
            
        }
        

    }
    
}
