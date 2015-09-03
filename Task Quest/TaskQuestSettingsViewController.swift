//
//  TaskQuestSettingsViewController.swift
//  Task Quest
//
//  Created by Anthony Zaprzalka on 8/20/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit

class TaskQuestSettingsViewController: UIViewController {

    @IBOutlet weak var settingsScrollView: UIScrollView!
    
    
    
    
    
    
    
    
    
    
    @IBAction func goBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsScrollView.contentSize = view.bounds.size

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
