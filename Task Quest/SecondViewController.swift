//
//  SecondViewController.swift
//  ToDo Quest
//
//  Created by Anthony Zaprzalka on 7/17/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var currentHeroLevel: UILabel!
    @IBOutlet weak var nextHeroLevel: UILabel!
    @IBOutlet weak var progressHeroLevel: UIProgressView!
    @IBOutlet weak var textXPLabel: UILabel!
    
    let topXP:Float = 100
    var bottomXP:Float = 0
    

    
    
    @IBAction func showXPButton(sender: AnyObject) {
        textXPLabel.alpha = 1.0
        
        let formatBottomXP = NSString(format: "%.0f", bottomXP)
        let formatTopXP = NSString(format: "%.0f", topXP)
        
        textXPLabel.text = "\(formatBottomXP)/\(formatTopXP)"
        
        updateProgressView()
        
        bottomXP++
        
        UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {self.textXPLabel.alpha = 0.0}, completion: nil)
        
    }
    
    func updateProgressView() {
        let fractionalProgress = bottomXP/topXP
        
        progressHeroLevel.setProgress(fractionalProgress, animated: true)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateProgressView()
        textXPLabel.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

