//
//  AddNewItemModalView.swift
//  ToDo Quest
//
//  Created by Anthony Zaprzalka on 7/19/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit

let reloadActiveViewControllerTableViewNotification = "reloadActiveTableViewNotification"

class AddNewItemModalView: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questTitle: UITextField!
    @IBOutlet weak var questGiver: UITextField!
    @IBOutlet weak var questNotes: UITextView!
    @IBOutlet weak var addNotesLabel: UILabel!
    @IBOutlet weak var completionDatePicker: UIDatePicker!

    // Determining which text field is active
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case questTitle:
            questTitle.resignFirstResponder()
            questGiver.becomeFirstResponder()
        case questGiver:
            questGiver.resignFirstResponder()
            questNotes.becomeFirstResponder()
        default:
            return false
        }
        return false
    }
    
    // MARK: - Adding toolbar to keyboard
    // TextField toolbar
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let doneKeyboardButton = UIToolbar()
        doneKeyboardButton.sizeToFit()
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("stopEditing"))
        let toolbarButtons = [flexibleSpaceItem, doneItem]
        
        doneKeyboardButton.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = doneKeyboardButton
        
        return true
    }
    
    func textFieldDidEndEditing(textView: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    // TextView toolbar
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
    
    // Both the textField and textView use this function
    func stopEditing() {
        self.view.endEditing(true)
    }
    
    // Showing or hiding the label if text was inputted
    func textViewDidBeginEditing(textView: UITextView) {
        addNotesLabel.hidden = true
    }
    func textViewDidEndEditing(textView: UITextView) {
        if self.questNotes.text == ""{
            addNotesLabel.hidden = false
        }
    }
    
    // MARK: - DatePicker Action
    @IBAction func datePickerAction(sender: UIDatePicker) {
    }
    
    @IBAction func addNewQuestButton(sender: AnyObject) {
        // First check to see if a quest was inputted when Accept is tapped.
        if questTitle.text! == "" {
            showEmptyTitleError()
        } else {
        
        let newQuest = QuestCoreDataEvents()
        // Save the quest
        let didSave = newQuest.saveQuest("NewQuest", title: questTitle.text!, givenBy: questGiver.text!, notes: questNotes.text!, date: completionDatePicker.date, amtXP: nil)
        // Error checking receiving
        if didSave == false {
            print("The Quest failed to save")
            print("didSave == \(didSave)")
        } else {
            print("The Quest saved correctly")
            print("didSave == \(didSave)")
        }
        
        // Then dismiss the viewController
            self.dismissViewControllerAnimated(true, completion: {(NSNotificationCenter.defaultCenter().postNotificationName(reloadActiveViewControllerTableViewNotification, object: nil))})
        }
    }
    
    @IBAction func cancelAddNewQuestButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showEmptyTitleError() {
        let emptyQuest = UIAlertController(title: "Empty Quest", message: "You cannot save an empty quest!", preferredStyle: UIAlertControllerStyle.Alert)
        emptyQuest.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(emptyQuest, animated: true, completion: nil)
    }
    
    func formatInputViews() {
        addNotesLabel.hidden = false
        
        let currentDate = NSDate()
        completionDatePicker.minimumDate = currentDate
        completionDatePicker.date = currentDate
        
        questTitle.attributedPlaceholder = NSAttributedString(string:"What needs to be done?", attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        questGiver.attributedPlaceholder = NSAttributedString(string: "Given By?", attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
    }
 
    // MARK: - Given Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatInputViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
