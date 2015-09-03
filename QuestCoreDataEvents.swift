//
//  QuestCoreDataEvents.swift
//  Task Quest
//
//  Created by Anthony Zaprzalka on 8/15/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class QuestCoreDataEvents {
    
    var questEntityName: String?
    var title: String?
    var givenBy: String?
    var notes: String?
    var date: NSDate?
    var amtXP : NSNumber?
    
    // MARK: Save Quest by entity name
    func saveQuest(questEntityName: String, title: String, givenBy: String, notes: String, date: NSDate, amtXP: NSNumber?) -> Bool {
        // Get the context of the object to be saved
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Insert the entity into the managedContext
        let entity = NSEntityDescription.entityForName("\(questEntityName)", inManagedObjectContext: managedContext)
        let quest = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        // Set the values
        quest.setValue(title, forKey: "title")
        quest.setValue(givenBy, forKey: "givenBy")
        quest.setValue(notes, forKey: "notes")
        quest.setValue(date, forKey: "date")
        
        if questEntityName == "CompletedQuest" {
            quest.setValue(amtXP, forKey: "CompletedXP")
        }
        
        print("The final new quest to be saved is \n \(quest)")
        
        // Save to disk and error check
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                print("There occurred an error of \(nserror), \(nserror.userInfo)")
                return false
            }
        }
        return true
    }
    
    // MARK: Update the quest once already entered in
    func updateActiveQuestByPredicate(questPredicateReference: String, title: String, givenBy: String, notes: String, date: NSDate) -> Bool {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "NewQuest")
        let predicate = NSPredicate(format: "title == %@", questPredicateReference)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchResults {
                let result = results[0]
                result.setValue(title, forKey: "title")
                result.setValue(givenBy, forKey: "givenBy")
                result.setValue(notes, forKey: "notes")
                result.setValue(date, forKey: "date")
            }
            if managedContext.hasChanges {
                do {
                    try managedContext.save()
                } catch {
                    let nserror = error as NSError
                    print("There occurred an error of \(nserror), \(nserror.userInfo)")
                    return false
                }
            }
        } catch {
            let nserror = error as NSError
            print("There occurred an error of \(nserror), \(nserror.userInfo)")
            return false
        }
        return true
    }
    
    // MARK: Delete entire quest list by entity name
    func deleteSpecifiedQuestList(questEntityName: String) -> Bool {
        var currentQuestList = [NSManagedObject]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "\(questEntityName)")
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchResults {
                currentQuestList = results
            }
        } catch {
            let nserror = error as NSError
            print("There occurred an error of \(nserror), \(nserror.userInfo)")
        }
        
        // Now to delete it
        if currentQuestList.count == 0 {
            print("The array is empty")
            return false
        }
        let currentRecord = currentQuestList[0]
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchResults {
                for currentRecord in currentQuestList {
                    managedContext.deleteObject(currentRecord)
                    if managedContext.hasChanges {
                        do {
                            try managedContext.save()
                        } catch {
                            let nserror = error as NSError
                            print("There occurred an error of \(nserror), \(nserror.userInfo)")
                            return false
                        }
                    }
                }
            }
        } catch {
            let nserror = error as NSError
            print("There occurred an error of \(nserror), \(nserror.userInfo)")
            return false
        }
        return true
    }
    
    // MARK: Delete active quest at table view
    func deleteActiveQuestAtTableByPredicate(activeQuestList: [NSManagedObject], indexPath: NSIndexPath) -> Bool {
        
        let questPredicateReference = activeQuestList[indexPath.row].valueForKey("title") as! String
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "NewQuest")
        let predicate = NSPredicate(format: "title == %@", questPredicateReference)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let result = fetchResults {
                for deletionRequest in result {
                    managedContext.deleteObject(deletionRequest)
                    if managedContext.hasChanges {
                        do {
                            try managedContext.save()
                        } catch {
                            let nserror = error as NSError
                            print("\(nserror), \(nserror.userInfo)")
                            return false
                        }
                    }
                }
            }
        } catch {
            let nserror = error as NSError
            print("\(nserror), \(nserror.userInfo)")
            return false
        }
        return true
    }
    
    //MARK: Delete Active Quest by Predicate name
    func deleteQuestByPredicate(questPredicateReference: String) -> Bool {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "NewQuest")
        let predicate = NSPredicate(format: "title == %@", questPredicateReference)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let result = fetchResults {
                for deletionRequest in result {
                    managedContext.deleteObject(deletionRequest)
                    if managedContext.hasChanges {
                        do {
                            try managedContext.save()
                        } catch {
                            let nserror = error as NSError
                            print("\(nserror), \(nserror.userInfo)")
                            return false
                        }
                    }
                }
            }
        } catch {
            let nserror = error as NSError
            print("\(nserror), \(nserror.userInfo)")
            return false
        }
        return true
    }
}

















