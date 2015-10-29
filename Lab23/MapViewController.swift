//
//  MapViewController.swift
//  Lab18
//
//  Created by karar on 20/04/15.
//  Copyright (c) 2015 karar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var diary: Diary!
    var manager: CLLocationManager!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("map view did load")
        
        // Get permission to fetch user's location
        self.manager = CLLocationManager()
        self.manager.requestWhenInUseAuthorization()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Show user on map
        self.mapView.showsUserLocation = true
        
        // Fetch a pre-existing or the newly created Diary from appDelegate
        self.diary = appDelegate.diary
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Re-render all annotations
        println("map view will appear")
        updateMap()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func updateMap() {
        // Load the diary's entries, sorted by date
        var sortedDiary = self.diary.getSorted()
        
        // Clear all previous annotations
        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        
        // Generate annotations for all entries
        for (index, day) in enumerate(sortedDiary) {
            for (i, entry) in enumerate(day.entries) {
                // Send annotation to be created (reverse geocoding is async so we can't do it here synchronously)
                createAnnotation(entry)
            }
        }
    }
    
    func createAnnotation(entry: DiaryEntry) {
        // Initialize the date formatter for printing dates
        var f = NSDateFormatter()
        f.dateFormat = "dd.MM.YYYY"
        
        // Create the base annotation
        var annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: entry.location.coordinate.latitude, longitude: entry.location.coordinate.longitude) // Fetch the location
        annotation.title = entry.text // Actual entry
        annotation.subtitle = f.stringFromDate(entry.date) // And date
        
        // Get street address from location data
        annotation.subtitle = annotation.subtitle + " @\(entry.locationString)"
        
        mapView.addAnnotation(annotation)
    }
    
}
