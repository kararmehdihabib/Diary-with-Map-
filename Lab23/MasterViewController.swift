//
//  MasterViewController.swift
//  Lab23
//
//  Created by mikko on 27/04/15.
//  Copyright (c) 2015 mikko. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var diary: Diary!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        self.diary = self.appDelegate.diary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        //objects.insert(NSDate(), atIndex: 0)
        //let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        //self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        println("adding new item, should segue to new view")
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let entry = self.diary.getSorted()[indexPath.section].entries[indexPath.row] as DiaryEntry
                (segue.destinationViewController as DetailViewController).detailItem = entry
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.diary.entries.count // Amount of days == sections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.diary.entries[section].dateString
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diary.entries[section].entries.count // Amount of entries (rows) in one day (section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Queue a cell
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryEntryCell", forIndexPath: indexPath) as UITableViewCell

        // Fill it with entry-data
        let entry = self.diary.entries[indexPath.section].entries[indexPath.row] as DiaryEntry
        cell.textLabel?.text = entry.text // Actual text entry
        cell.detailTextLabel?.text = entry.locationString // Location of the entry
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Only manage deletion case
        if editingStyle == .Delete {
            // Remove the deleted item from the model
            self.diary.entries[indexPath.section].entries.removeAtIndex(indexPath.row)
            
            // Remove the deleted item from the UITableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Remove sections that no longer have any entries
            if self.diary.entries[indexPath.section].entries.count == 0 {
                self.diary.entries.removeAtIndex(indexPath.section)
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            }
        }
    }


}

