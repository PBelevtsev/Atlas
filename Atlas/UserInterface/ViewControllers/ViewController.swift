//
//  ViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/26/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if let navigation = self.navigationController {
            if (!navigation.navigationBar.isHidden) {
                navigation.setNavigationBarHidden(true, animated: animated);
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
     
        if let navigation = self.navigationController {
            navigation.setNavigationBarHidden(false, animated: animated);
        }
    }
}

