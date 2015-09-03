//
//  CompletedCellViewController.swift
//  Task Quest
//
//  Created by Anthony Zaprzalka on 8/12/15.
//  Copyright © 2015 Anthony Zaprzalka. All rights reserved.
//

import UIKit

class CompletedCellViewController: UIViewController {

    @IBOutlet weak var completedQuestTitle: UILabel!
    @IBOutlet weak var completedQuestGivenBy: UILabel!
    @IBOutlet weak var completedQuestDate: UILabel!
    @IBOutlet weak var completedQuestNotes: UITextView!
    @IBOutlet weak var completedQuestXP: UILabel!
    
    var detailCompletedQuest: CompletedQuest?
    
    @IBAction func completedQuestClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setCompletedLabels(currentCompletedQuest: CompletedQuest) {
        completedQuestTitle.text = currentCompletedQuest.title
        completedQuestGivenBy.text = currentCompletedQuest.givenBy
        completedQuestNotes.text = currentCompletedQuest.notes
        completedQuestXP.text = "\(currentCompletedQuest.amtXP.stringValue) XP Awarded"
        
        // Format the date so it is readable
        let dateFormatterTime = NSDateFormatter()
        let dateFormatterDate = NSDateFormatter()
        
        dateFormatterTime.timeStyle = NSDateFormatterStyle.ShortStyle
        
        dateFormatterDate.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let completionTime = dateFormatterTime.stringFromDate(currentCompletedQuest.date)
        let completionDate = dateFormatterDate.stringFromDate(currentCompletedQuest.date)
        
        completedQuestDate.text = "Completed on \(completionDate) at \(completionTime)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setCompletedLabels(detailCompletedQuest!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
