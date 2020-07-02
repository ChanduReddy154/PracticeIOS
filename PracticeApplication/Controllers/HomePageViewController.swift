//
//  HomePageViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 23/06/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import SideMenu

class HomePageViewController: UIViewController {
    var menu: SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        menu = SideMenuNavigationController(rootViewController: UIViewController())
        
    }
    
   
   
    

}
