//
//  CompletedViewController.swift
//  ToDo Quest
//
//  Created by Anthony Zaprzalka on 7/16/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit
import CoreData

class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var completedQuestList = [NSManagedObject]()
    
    @IBOutlet weak var completedTableView: UITableView!
    
    //MARK: - Table functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedQuestList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCompletedCell", forIndexPath: indexPath) as UITableViewCell
        
        let (reminderName) = completedQuestList[indexPath.row]
        cell.textLabel!.text = reminderName.valueForKey("title") as? String
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    @IBAction func deleteCompletedList(sender: AnyObject) {
        // let deletion = CompletedQuestModel()
        // let deletionBool = deletion.deleteCompletedList()
        let completedQuestListDeletion = QuestCoreDataEvents()
        let didCorrectlyDeleteBool = completedQuestListDeletion.deleteSpecifiedQuestList("CompletedQuest")
        if didCorrectlyDeleteBool == true {
            print("The list was successfully deleted")
            print("didCorrectlyDeleteBool == \(didCorrectlyDeleteBool)")
        } else {
            print("The list was unsuccessfully deleted\nOr the list is empty")
            print("didCorrectlyDeleteBool == \(didCorrectlyDeleteBool)")
        }
        reloadReminderData()
    }
    
    func reloadReminderData() {
        // Fetch from Core Data to populate the active list
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Fetch the Entities with the matching entityName
        let fetchRequest = NSFetchRequest(entityName: "CompletedQuest")
        
        //
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchResults {
                completedQuestList = results
                
                // Reverse the list order. Should switch this into a settings file...
                completedQuestList = completedQuestList.reverse()
            }
        } catch let error as NSError {
            print("ERROR of \(error), \(error.userInfo)")
        }
        
        // Reload the table view
        dispatch_async(dispatch_get_main_queue()) {
            self.completedTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "completedCellViewControllerSegue" {
            if let indexPath = self.completedTableView.indexPathForSelectedRow {
                let completedTitle = completedQuestList[indexPath.row].valueForKey("title") as! String
                let completedGiver = completedQuestList[indexPath.row].valueForKey("givenBy") as! String
                let completedNotes = completedQuestList[indexPath.row].valueForKey("notes") as! String
                let completedDate = completedQuestList[indexPath.row].valueForKey("date") as! NSDate
                let completedXP = completedQuestList[indexPath.row].valueForKey("completedXP") as! NSNumber
                
                let currentCompletedQuest = CompletedQuest(title: completedTitle , givenBy: completedGiver , notes: completedNotes , date: completedDate, amtXP: completedXP )
                
                let controller = (segue.destinationViewController) as! CompletedCellViewController
                controller.detailCompletedQuest = currentCompletedQuest
            }
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completedTableView.backgroundColor = UIColor.clearColor()
        completedTableView.tableFooterView = UIView(frame:CGRectZero)
        completedTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        completedTableView.separatorColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadReminderData()
    }
    
    // didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
