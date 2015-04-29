//
//  AddEntryViewController.swift
//  Lab23
//
//  Created by mikko on 27/04/15.
//  Copyright (c) 2015 mikko. All rights reserved.
//

import UIKit
import MapKit
import MobileCoreServices

class AddEntryViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var diary: Diary!
    var manager: CLLocationManager!
    var newEntry: DiaryEntry!
    var destinationController: UITableViewController?
    
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get permission to fetch user's location
        self.manager = CLLocationManager()
        self.manager.requestWhenInUseAuthorization()
        
        self.diary = self.appDelegate.diary
        self.picker?.delegate = self
        
        self.imageView.image = UIImage(named: "entryDefaultImg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // NOTE: Do we need this, or is it a simulator issue that manager is not starting?
        self.manager.requestWhenInUseAuthorization()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("preparing for a segue")
        // The user cancelled, no need to save
        if sender as UIBarButtonItem! != self.saveButton {
            return
        }
        
        self.destinationController = segue.destinationViewController as? UITableViewController
        
        // Start updating location, and when it is received, add new entry
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        self.saveButton.enabled = false
    }
    
    func addNewEntry(location: CLLocation, locationString: String) {
        
        // Add entry to the diary
        self.diary.addEntry(DiaryEntry(date: self.datePicker.date, text: self.textInput.text, location: location, locationString: locationString, image: self.imageView.image!))
        
        // Clear previous input
        self.textInput.text = ""
        
        // Re-enable the add-button
        self.saveButton.enabled = true
        
        if let tv = self.destinationController?.tableView {
            println("telling destinationController to reloadData")
            tv.reloadData()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location: " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locationString = ""
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                println("Reverse geocoding failed: " + error.localizedDescription)
            }
            
            if placemarks.count > 0 {
                println("found a place to add as new entry's location")
                let pm = placemarks[0] as CLPlacemark
                
                // Thoroughfare == street address, subThoroughfare == street number
                if pm.thoroughfare != nil {
                    locationString = "\(pm.thoroughfare) \(pm.subThoroughfare)"
                } else if pm.areasOfInterest != nil {
                    locationString = "\(pm.areasOfInterest[0])"
                } else if pm.locality != nil {
                    locationString = "\(pm.locality)"
                } else {
                    locationString = "\(pm.country)"
                }
                
                // When a location is found, add a new entry
                self.addNewEntry(manager.location, locationString: locationString)
                self.manager.stopUpdatingLocation()
                
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    @IBAction func chooseImageClicked(sender: AnyObject) {
        var alert:UIAlertController=UIAlertController(title: "Choose Image for Entry", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallery()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        // Add the actions
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.popover = UIPopoverController(contentViewController: alert)
            self.popover!.presentPopoverFromRect(self.chooseImageBtn.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func openGallery() {
        println("opening gallery")
        
        self.picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone  {
            self.presentViewController(self.picker!, animated: true, completion: nil)
        } else {
            self.popover = UIPopoverController(contentViewController: self.picker!)
            self.popover!.presentPopoverFromRect(self.chooseImageBtn.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        println("user finished picking media")
        
        let mediaType = info[UIImagePickerControllerMediaType] as String
        var originalImage: UIImage?
        var imageUrl: String?
        
        // If a still image was captured, handle it
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        
        if compResult == CFComparisonResult.CompareEqualTo {
            originalImage = info[UIImagePickerControllerOriginalImage] as UIImage?
            imageUrl = info[UIImagePickerControllerMediaURL] as String?
            self.imageView.image = originalImage
        }
        
        self.picker!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker!.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func resetImageClicked(sender: AnyObject) {
        self.imageView!.image = UIImage(named: "entryDefaultImg")
    }
}
