//
//  DetailsVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import CoreLocation
import MapKit

class DetailsVC: UIViewController {
    
    static let storyboardIdentifier = "DetailsVC"
    
    //getPost from the table cell directly bring to detail
    var getPost : Post?
    
    @IBOutlet weak var descriptionSetLabel: UILabel!
    @IBOutlet weak var timeSetLabel: UILabel!
    @IBOutlet weak var categorySetLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var JoinButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayText()
        initDetailView()
        self.navigationItem.title = "Event Details"
        
    }
    
    func displayText()  {
        titleLabel.text = getPost?.title
        descriptionLabel.text = getPost?.description
        imageView.sd_setImage(with:getPost?.imageURL)
        timeLabel.text = getPost?.time
        categoryLabel.text = getPost?.category
        
        
        let myLocation = MKPointAnnotation()
        myLocation.coordinate = CLLocationCoordinate2DMake((getPost?.lat)!, (getPost?.long)!)
        
        mapView.addAnnotation(myLocation)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(myLocation.coordinate, span)
        //                                  add notation, getlat.long, zoom
        mapView.setRegion(region, animated: true)
        
    }
    
    func initDetailView() {
        
        UIDesign().setLabel(lable: descriptionSetLabel)
        UIDesign().setLabel(lable: timeSetLabel)
        UIDesign().setLabel(lable: categorySetLabel)
        UIDesign().setLabel(lable: titleLabel)
        UIDesign().setLabel(lable: descriptionLabel)
        UIDesign().setLabel(lable: timeLabel)
        UIDesign().setLabel(lable: categoryLabel)
        
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
    }
}
