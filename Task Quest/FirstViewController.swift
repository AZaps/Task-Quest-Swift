//
//  FirstViewController.swift
//  ToDo Quest
//
//  Created by Anthony Zaprzalka on 7/14/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    @IBOutlet weak var questCompletionTab: UISegmentedControl!
    @IBOutlet weak var activeTabContainer: UIView!
    @IBOutlet weak var completedTabContainer: UIView!
    @IBOutlet weak var addReminderOutlet: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var recievedNewQuest : NewQuest?
    
    //MARK: - Switch statement for choosing the correct segemented control tab
    @IBAction func questCompletionTabChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            activeTabContainer.hidden = false
            completedTabContainer.hidden = true
            addReminderOutlet.enabled = true
            
        case 1:
            activeTabContainer.hidden = true
            completedTabContainer.hidden = false
            addReminderOutlet.enabled = false
            
        default:
            print("Not selected correctly")
        }
    }
    
    // MARK: Add new Quest Button
    @IBAction func addToListButton(sender: AnyObject) {
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addToListButton" {
            segue.destinationViewController as! AddNewItemModalView
        } else if segue.identifier == "activeViewControllerSegue" {
        } else if segue.identifier == "completedViewControllerSegue" {
        }
    }
    
    func setViewItems() {
        questCompletionTab.selectedSegmentIndex = 0
        
        activeTabContainer.hidden = false
        completedTabContainer.hidden = true
        addReminderOutlet.enabled = true
        
        activeTabContainer.backgroundColor = UIColor.clearColor()
        completedTabContainer.backgroundColor = UIColor.clearColor()
        
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        questCompletionTab.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Selected)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewItems()
    }
    
    // didRecieveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}









