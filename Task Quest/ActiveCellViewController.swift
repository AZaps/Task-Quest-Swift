//
//  ActiveCellViewController.swift
//  Task Quest
//
//  Created by Anthony Zaprzalka on 8/3/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

class ActiveCellViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var questTitleLabel: UITextField!
    @IBOutlet weak var questGivenByLabel: UITextField!
    @IBOutlet weak var questNotesLabel: UITextView!
    @IBOutlet weak var questCompletionDate: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!

    @IBOutlet weak var deleteOrCompleteButtonLabel: UIButton!
    @IBOutlet weak var editButtonLabel: UIButton!
    @IBOutlet weak var closeButtonLabel: UIButton!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var questDelCompLabel: UILabel!
    @IBOutlet weak var amtXPLabel: UILabel!
    
    @IBOutlet weak var updateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerButtonOutlet: UIButton!
    
    @IBOutlet weak var viewDatePicker: UIView!
    
    var dropDownDatePickerShown = false
    
    var activeQuest : NewQuest?
    var editPressed = false
    
    let sampleCalendar = NSCalendar.currentCalendar()
    
    var dayPlural = "day"
    var hourPlural = "hour"
    var minutePlural = "minute"
    var questPastDue = false
    
    let arrayXP = [10, 15, 20]
    
    var boundsHeight : CGFloat?
    var boundsWidth : CGFloat?
    
    // MARK: - Dismiss the keyboard with the Done button
    @IBAction func activeCellDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Edit Quest Button functions
    // Edit Button
    @IBAction func editQuestButton(sender: AnyObject) {
        // Check to see state of the button
        if editPressed == false {
            changeToDelete() // will change editPressed == true
            
            // Make labels editable
            changeInputsToBeEditable()
            
        } else if editPressed == true {
            // Return label back to default state
            changeToComplete() // will change editPressed == false
            
            // Return labels to default state
            changeInputsToBeEditable()
            
            // Check to see if any of the labels have been edited and if so, save the new
            checkIfLabelsEdited()
            
            if dropDownDatePickerShown == true {
                revertViewDatePicker()
                dropDownDatePickerShown = false
            }
            
        }
    }
    
    // Change the label to Complete and various functions to apply
    func changeToComplete() {
        // Button label changes used multiple times, once the 'Edit' or 'Done' button is pressed.
        editPressed = false
        closeButtonLabel.enabled = true
        deleteOrCompleteButtonLabel.setTitle("Complete Quest", forState: .Normal)
        editButtonLabel.setTitle("Edit", forState: .Normal)
    }
    
    // Change the label to Delete and various functions to apply
    func changeToDelete() {
        editPressed = true
        closeButtonLabel.enabled = false
        deleteOrCompleteButtonLabel.setTitle("Delete Quest", forState: .Normal)
        editButtonLabel.setTitle("Done", forState: .Normal)
    }
    
    // Various labels to be flip-flop interactivity
    func changeInputsToBeEditable() {
        if editPressed == false {
            // Revert labels to uneditable state
            questTitleLabel.userInteractionEnabled = false
            questGivenByLabel.userInteractionEnabled = false
            questNotesLabel.editable = false
            datePickerButtonOutlet.userInteractionEnabled = false
            
            questTitleLabel.textColor = UIColor.blackColor()
            questGivenByLabel.textColor = UIColor.blackColor()
            questNotesLabel.textColor = UIColor.blackColor()
            
        } else if editPressed == true {
            // Change labels to editable state
            questTitleLabel.userInteractionEnabled = true
            questGivenByLabel.userInteractionEnabled = true
            questNotesLabel.editable = true
            datePickerButtonOutlet.userInteractionEnabled = true

            questTitleLabel.textColor = UIColor.redColor()
            questGivenByLabel.textColor = UIColor.redColor()
            questNotesLabel.textColor = UIColor.redColor()
        }
    }
    
    // MARK: - Drop Down datePicker actions
    @IBAction func showDatePickerButton(sender: AnyObject) {
        if dropDownDatePickerShown == false {
            // Show the view
            dropDownDatePickerShown = true
            
            questNotesLabel.userInteractionEnabled = false
            questNotesLabel.hidden = true
            
            viewDatePicker.layer.zPosition = 1
    
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {self.viewDatePicker.transform = CGAffineTransformIdentity}, completion: nil)
            
        } else if dropDownDatePickerShown == true {
            // Get the date and resave it
            
            // Remove the view
            dropDownDatePickerShown = false
            
            questNotesLabel.userInteractionEnabled = true
            
            revertViewDatePicker()
            
        }
    }
    
    func revertViewDatePicker() {
        UIView.animateKeyframesWithDuration(0.25, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModePaced, animations: {
            
            // note that we've set relativeStartTime and relativeDuration to zero.
            // Because we're using `CalculationModePaced` these values are ignored
            // and iOS figures out values that are needed to create a smooth constant transition
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.viewDatePicker.transform = CGAffineTransformMakeScale(0.75, 0.75)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.viewDatePicker.transform = CGAffineTransformMakeScale(0.5, 0.5)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.viewDatePicker.transform = CGAffineTransformMakeScale(0.25, 0.25)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.viewDatePicker.transform = CGAffineTransformMakeScale(0, 0)
            })
            
            }, completion: {Void in self.questNotesLabel.hidden = false})
    }
    
    // Check if label was edited
    func checkIfLabelsEdited() {
        if questTitleLabel.text != activeQuest?.title {
            print("Title label was edited")
            updateActiveQuest()
        } else if questGivenByLabel.text != activeQuest?.givenBy {
            print("GivenBy label was edited")
            updateActiveQuest()
        } else if questNotesLabel.text != activeQuest?.notes {
            print("Notes label was edited")
            updateActiveQuest()
        } else if datePicker.date != activeQuest?.date {
            print("Date was edited")
            updateActiveQuest()
        }
    }
    
    // MARK: - Update the quest if edited
    func updateActiveQuest() {
        let editedActiveQuest = QuestCoreDataEvents()
        
        let didUpdateCorrectly = editedActiveQuest.updateActiveQuestByPredicate((activeQuest?.title)!, title: questTitleLabel.text!, givenBy: questGivenByLabel.text!, notes: questNotesLabel.text!, date: datePicker.date)
        if didUpdateCorrectly == true {
            print("The quest updated correctly")
            updateLabelBlur("Successfully Updated")
        } else {
            print("The quest did not update correctly")
            updateLabelBlur("Unsuccessfully Updated")
        }
    }
    
    // Show the label
    func updateLabelBlur(labelTitle: String) {
        updateLabel.text = labelTitle
        UIView.animateWithDuration(1.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {self.updateLabel.alpha = 0.0}, completion: {Void in self.dismissViewAfterUpdate()})
        
    }
    
    func dismissViewAfterUpdate() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TextView toolbar
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        let doneKeyboardButton = UIToolbar()
        doneKeyboardButton.sizeToFit()
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("stopEditing"))
        let toolbarButtons = [flexibleSpaceItem, doneItem]
        
        doneKeyboardButton.setItems(toolbarButtons, animated: false)
        textView.inputAccessoryView = doneKeyboardButton
        
        return true
    }
    
    func stopEditing() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - Checking if the delete or complete button was pressed
    @IBAction func deleteOrCompleteButton(sender: AnyObject) {
        if editPressed == false {
            // label the quest as complete and move to 'Completed Quest Tab'
            let newCompletedQuest = QuestCoreDataEvents()
            
            // Save current date of completed quest
            let completedDate = NSDate()
            
            let randomXP = Int(arc4random_uniform(UInt32(arrayXP.count)))
            
            let didSaveCorrectlyBool = newCompletedQuest.saveQuest("CompletedQuest", title: (activeQuest?.title)!, givenBy: (activeQuest?.givenBy)!, notes: (activeQuest?.notes)!, date: completedDate, amtXP: (arrayXP[randomXP]))
            
            if didSaveCorrectlyBool == true {
                print("The active quest was moved to completed successfully")
                print("didSaveCorrectlyBool == \(didSaveCorrectlyBool)")
                let didDeleteCorrectlyBool = newCompletedQuest.deleteQuestByPredicate((activeQuest?.title)!)
                if didDeleteCorrectlyBool == true {
                    print("The old Active Quest was deleted correctly")
                    print("didDeleteCorrectlyBool == \(didDeleteCorrectlyBool)")
                } else {
                    print("The old Active Quest was unsuccessfully deleted")
                    print("didDeleteCorrectlyBool == \(didDeleteCorrectlyBool)")
                }
            } else {
                print("The active quest was moved to completed unsuccessfully")
                print("didSaveCorrectlyBool == \(didSaveCorrectlyBool)")
            }
            
            //Blur screen, show completed message and amount xp, then dismiss view
            questDelCompLabel.text = "Quest Completed"
            amtXPLabel.text = "+\(arrayXP[randomXP]) XP"
            screenBlur()
            
        } else if editPressed == true {
            // double-check to see if the user still wants to delete the quest
            let deletionAlert = UIAlertController(title: "Delete Quest", message: "Are you sure you want to delete this quest?", preferredStyle: UIAlertControllerStyle.Alert)
            // User does not want to delete the quest
            deletionAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: deletionAlertHandler))
            // User wants to delete the quest
            deletionAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: deletionAlertHandler))
            // Show the alert
            self.presentViewController(deletionAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Handle deletion events
    func deletionAlertHandler(alertView: UIAlertAction!){
        // Handle which event was tapped
        switch alertView.style{
        case .Cancel:
            changeToComplete()
        
        case .Destructive:
            // Revert labels
            changeToComplete()
            
            // Handle the deletion request
            let deleteCurrentActiveQuest = QuestCoreDataEvents()
            let didDeleteCorrectly = deleteCurrentActiveQuest.deleteQuestByPredicate((activeQuest?.title)!)
            
            if didDeleteCorrectly == true {
                print("The Quest was successfully deleted")
            } else {
                print("The Quest was unsuccessfully deleted")
            }
            
            //Blur screen, show deleted message and dismiss view
            questDelCompLabel.text = "Quest Deleted"
            amtXPLabel.hidden = true
            screenBlur()
            
        case .Default:
            print("Default case somehow?")
        }
    }
    
    func screenBlur() {
        UIView.animateWithDuration(1.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {self.blurEffect.alpha = 1.0}, completion: nil)
        
        // Delay for two seconds
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Formatting the view
    func formatViewAndLabels(currentQuest: NewQuest) {
        deleteOrCompleteButtonLabel.setTitle("Complete Quest", forState: .Normal)
        closeButtonLabel.enabled = true
        self.blurEffect.alpha = 0.0
        
        self.updateLabel.text = ""
        
        boundsWidth = viewDatePicker.bounds.size.width
        boundsHeight = viewDatePicker.bounds.size.height
        viewDatePicker.layer.anchorPoint = CGPointMake(0.5, -0.5)
        viewDatePicker.transform = CGAffineTransformMakeScale(0, 0)
        viewDatePicker.backgroundColor = UIColor.clearColor()
        
        datePicker.minimumDate = activeQuest?.date
        datePicker.setDate((activeQuest?.date)!, animated: false)
        
        questTitleLabel.text = currentQuest.title
        questGivenByLabel.text = currentQuest.givenBy
        questNotesLabel.text = currentQuest.notes
        
        // Format the date so it is readable
        let dateFormatterTime = NSDateFormatter()
        let dateFormatterDate = NSDateFormatter()
        
        dateFormatterTime.timeStyle = NSDateFormatterStyle.ShortStyle
        
        dateFormatterDate.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let completionTime = dateFormatterTime.stringFromDate(currentQuest.date)
        let completionDate = dateFormatterDate.stringFromDate(currentQuest.date)
        
        questCompletionDate.text = "\(completionDate) by \(completionTime)"
        
        let remainingTime = remainingTimeLeft(currentQuest.date)
        
        // Checking for plural usage of the date
        if remainingTime?.day == 1 {
            dayPlural = "day"
        } else {
            dayPlural = "days"
        }
        
        if remainingTime?.hour == 1 {
            hourPlural = "hour"
        } else {
            hourPlural = "hours"
        }
        
        if remainingTime?.minute == 1 {
            minutePlural = "minute"
        } else {
            minutePlural = "minutes"
        }
        
        // Ouputting the remaining time left
        if remainingTime == nil {
            timeRemainingLabel.text = "Something is wrong with the date :("
        } else if questPastDue == false {
            timeRemainingLabel.textColor = UIColor.blackColor()
            timeRemainingLabel.text = "\(remainingTime!.day) \(dayPlural), \(remainingTime!.hour) \(hourPlural), \(remainingTime!.minute) \(minutePlural)"
        } else if questPastDue == true {
            // change color to red
            timeRemainingLabel.textColor = UIColor.redColor()
            timeRemainingLabel.text = "\(remainingTime!.day) \(dayPlural), \(remainingTime!.hour) \(hourPlural), \(remainingTime!.minute) \(minutePlural)"
        }
    }
    
    // MARK: - Calculation for remaining time
    func remainingTimeLeft(userDate: NSDate) -> (NSDateComponents?) {
        // Get current date and time
        let currentDateAndTime = NSDate()
        let dateOrder = userDate.compare(currentDateAndTime)
        
        if dateOrder == .OrderedAscending{
            // Will run if the user is behind on their quest
            // Compare the two dates to get elapsed time
            let remainingTime = sampleCalendar.components([.Day, .Hour, .Minute], fromDate: userDate, toDate: currentDateAndTime, options: [])
  
            questPastDue = true
            
            return remainingTime
            
        } else if dateOrder == .OrderedDescending {
            
            // currentDateAndTime is before the reminder time. What should usually run if the user is on track
            let remainingTime = sampleCalendar.components([.Day, .Hour, .Minute], fromDate: currentDateAndTime, toDate: userDate, options: [])
  
            questPastDue = false
            
            return remainingTime
        }
        return nil
    }
    
    // MARK: - viewDidLoad and didReceiveMemoryWarning
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatViewAndLabels(activeQuest!)
        
        changeInputsToBeEditable()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
