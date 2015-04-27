//
//  Diary.swift
//  Lab23
//
//  Created by mikko on 27/04/15.
//  Copyright (c) 2015 mikko. All rights reserved.
//

import Foundation
import MapKit

class Diary: NSObject, NSCoding {
    var entries: [DiaryDay]
    let DIARYENTRY_CELL_IDENTIFIER = "DiaryEntryCell"
    let DATE_FORMAT = "dd.MM.YYYY"
    
    /* NSCoding */
    required init(coder aDecoder: NSCoder) {
        // Load previous values
        self.entries = aDecoder.decodeObjectForKey("entries") as [DiaryDay]
    }
    
    override init() {
        self.entries = [DiaryDay]()
    }
    
    /* NSCoding */
    func encodeWithCoder(aCoder: NSCoder) {
        // Encode values for saving
        aCoder.encodeObject(self.entries, forKey: "entries")
    }
    
    func addEntry(date: NSDate, text: String, location: CLLocation, locationString: String) {
        // An entry must have some content
        if !text.isEmpty {
            var existingDateIndex = -1
            var f = NSDateFormatter()
            f.dateFormat = DATE_FORMAT
            
            for (index, day) in enumerate(self.entries) {
                if day.dateString == f.stringFromDate(date) {
                    existingDateIndex = index
                    break
                }
            }
            
            // Was a matching DiaryDay found
            if existingDateIndex >= 0 {
                // Generate a new entry and append it into the correct DiaryDay
                self.entries[existingDateIndex].entries.append(DiaryEntry(date: date, text: text, location: location, locationString: locationString))
            } else {
                // Generate a new entry and a new DiaryDay for it
                self.entries.append(DiaryDay(date: date, firstEntry: DiaryEntry(date: date, text: text, location: location, locationString: locationString)))
            }
        }
    }
    
    // Get diary entries sorted by time, grouped by DiaryDay
    func getSorted() -> [DiaryDay] {
        // Sort within the days first
        self.entries = self.entries.map {
            $0.entries = $0.getSorted()
            return $0
        }
        
        // And then sort the days
        return sorted(self.entries, <)
    }
}