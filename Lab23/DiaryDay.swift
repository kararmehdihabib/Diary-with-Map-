//
//  DiaryDay.swift
//  Lab23
//
//  Created by mikko on 27/04/15.
//  Copyright (c) 2015 mikko. All rights reserved.
//

import Foundation

class DiaryDay: NSObject, Comparable, NSCoding {
    var date: NSDate
    var dateString: String
    var entries: [DiaryEntry]
    let DATE_FORMAT = "dd.MM.YYYY"
    
    /* NSCoding */
    required init(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
        self.dateString = aDecoder.decodeObjectForKey("dateString") as String
        self.entries = aDecoder.decodeObjectForKey("entries") as [DiaryEntry]
    }
    
    /* Init without a first entry */
    init(date: NSDate) {
        self.date = date
        self.entries = [DiaryEntry]()
        
        var f = NSDateFormatter()
        f.dateFormat = DATE_FORMAT
        self.dateString = f.stringFromDate(self.date)
    }
    
    /* Init with a first entry */
    init(date: NSDate, firstEntry: DiaryEntry) {
        self.date = date
        self.entries = [DiaryEntry]()
        self.entries.append(firstEntry)
        
        var f = NSDateFormatter()
        f.dateFormat = DATE_FORMAT
        self.dateString = f.stringFromDate(self.date)
    }
    
    /* NSCoding */
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.dateString, forKey: "dateString")
        aCoder.encodeObject(self.entries, forKey: "entries")
    }
    
    func getSorted() -> [DiaryEntry]{
        return sorted(self.entries, <)
    }
}

/* Comparable */
func <(lhs: DiaryDay, rhs: DiaryDay) -> Bool {
    return lhs.date.compare(rhs.date) == NSComparisonResult.OrderedAscending
}

func ==(lhs: DiaryDay, rhs: DiaryDay) -> Bool {
    return lhs.dateString == rhs.dateString
}