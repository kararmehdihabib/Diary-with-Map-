//
//  DetailViewController.swift
//  Lab23
//
//  Created by karar on 27/04/15.
//  Copyright (c) 2015 karar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!


    var detailItem: DiaryEntry? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: DiaryEntry = self.detailItem {
            // Safely unwrap labels before assigning values
            if let textLabel = self.detailDescriptionLabel {
                textLabel.text = detail.text
            }
            if let locLabel = self.detailLocationLabel {
                locLabel.text = detail.locationString
            }
            if let dateLabel = self.detailDateLabel {
                dateLabel.text = detail.dateString
            }
            if let img = self.detailImageView {
                img.image = detail.image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

