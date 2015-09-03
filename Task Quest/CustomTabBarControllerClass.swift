//
//  CustomTabBarControllerClass.swift
//  Task Quest
//
//  Created by Anthony Zaprzalka on 8/7/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit

class CustomTabBarControllerClass: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Tab bar color customization
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.tabBar.tintColor = UIColor.whiteColor()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
