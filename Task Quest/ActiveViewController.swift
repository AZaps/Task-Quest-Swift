//
//  ActiveViewController.swift
//  ToDo Quest
//
//  Created by Anthony Zaprzalka on 7/17/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit
import CoreData

class ActiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var activeQuest : NewQuest?
    
    var activeQuestList = [NSManagedObject]()

    @IBOutlet weak var activeTableView: UITableView!
    
    //MARK: - Table functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeQuestList.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            let deleteAtRow = QuestCoreDataEvents()
            let didDeleteAtRow = deleteAtRow.deleteActiveQuestAtTableByPredicate(activeQuestList, indexPath: indexPath)
            
            if didDeleteAtRow == true {
                print("The Quest was deleted successfully at the tableView")
                reloadReminderData()
            } else {
                print("The quest was unsuccessfully deleted at the tableView")
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myActiveCell", forIndexPath: indexPath) as UITableViewCell
        
        let (reminderName) = activeQuestList[indexPath.row]
        
        cell.textLabel!.text = reminderName.valueForKey("title") as? String
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func reloadReminderData() {
        // Fetch from Core Data to populate the active list
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Fetch the Entities with the matching entityName
        let fetchRequest = NSFetchRequest(entityName: "NewQuest")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        //
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchResults {
                activeQuestList = results
            }
        } catch let error as NSError {
            print("ERROR of \(error), \(error.userInfo)")
        }
        
        // Reload the table view
        dispatch_async(dispatch_get_main_queue()) {
            self.activeTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "activeCellViewControllerSegue" {
            if let indexPath = self.activeTableView.indexPathForSelectedRow {
                let currentTitle = activeQuestList[indexPath.row].valueForKey("title") as! String
                let currentGiver = activeQuestList[indexPath.row].valueForKey("givenBy") as! String
                let currentNotes = activeQuestList[indexPath.row].valueForKey("notes") as! String
                let currentDate = activeQuestList[indexPath.row].valueForKey("date") as! NSDate
        
                let currentQuest = NewQuest(title: currentTitle , givenBy: currentGiver , notes: currentNotes , date: currentDate )
                
                let controller = (segue.destinationViewController) as! ActiveCellViewController
                controller.activeQuest = currentQuest
            }
        }
    }
    
    func formatActiveTableView() {
        activeTableView.backgroundColor = UIColor.clearColor()
        activeTableView.tableFooterView = UIView(frame:CGRectZero)
        activeTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        activeTableView.separatorColor = UIColor.whiteColor()
    }
    
    dynamic private func receiveNotification(notification: NSNotification) {
        print("received notification == \(notification)")
        reloadReminderData()
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatActiveTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadReminderData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveNotification:" , name: reloadActiveViewControllerTableViewNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
