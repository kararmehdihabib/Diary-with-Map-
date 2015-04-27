//
//  DiaryEntry.swift
//  Lab23
//
//  Created by mikko on 27/04/15.
//  Copyright (c) 2015 mikko. All rights reserved.
//

import Foundation
import MapKit

class DiaryEntry: NSObject, Comparable, NSCoding {
    var date: NSDate
    var dateString: String
    var text: String
    var location: CLLocation
    var locationString: String
    let DATE_FORMAT = "dd.MM.YYYY"
    
    required init(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
        self.dateString = aDecoder.decodeObjectForKey("dateString") as String
        self.text = aDecoder.decodeObjectForKey("text") as String
        self.location = aDecoder.decodeObjectForKey("location") as CLLocation
        self.locationString = aDecoder.decodeObjectForKey("locationString") as String
    }
    
    init(date: NSDate, text: String, location: CLLocation, locationString: String) {
        self.date = date
        self.text = text
        self.location = location
        self.locationString = locationString
        
        var f = NSDateFormatter()
        f.dateFormat = DATE_FORMAT
        self.dateString = f.stringFromDate(self.date)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.dateString, forKey: "dateString")
        aCoder.encodeObject(self.text, forKey: "text")
        aCoder.encodeObject(self.location, forKey: "location")
        aCoder.encodeObject(self.locationString, forKey: "locationString")
    }
}

// Here we can also compare with times
func <(lhs: DiaryEntry, rhs: DiaryEntry) -> Bool {
    return lhs.date.compare(rhs.date) == NSComparisonResult.OrderedAscending
}

// Only compare the dates, not the times
func ==(lhs: DiaryEntry, rhs: DiaryEntry) -> Bool {
    return lhs.dateString == rhs.dateString
}