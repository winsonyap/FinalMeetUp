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

class DetailsVC: UIViewController {

    static let storyboardIdentifier = "DetailsVC"
    
    var posts : [Post] = []
    //getPost from the table cell directly bring to detail
    var getPost : Post?
    

    @IBOutlet weak var descriptionSetLabel: UILabel!
    @IBOutlet weak var timeSetLabel: UILabel!
    @IBOutlet weak var locationSetLabel: UILabel!
    @IBOutlet weak var categorySetLabel: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var joinORunjoinButton: UIButton!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        displayText()
        initDetailView()
        joinORunjoinButton.isEnabled =  false
    }
    
    func displayText()  {
        titleLabel.text = getPost?.title
        descriptionLabel.text = getPost?.description
        imageView.sd_setImage(with:getPost?.imageURL)
        timeLabel.text = getPost?.time
        locationLabel.text = getPost?.location
        categoryLabel.text = getPost?.category
    }
    
    func joinUnJoinButtonTapped()  {
        
    }
   
    func initDetailView() {
    
        UIDesign().setLabel(lable: descriptionSetLabel)
        UIDesign().setLabel(lable: timeSetLabel)
        UIDesign().setLabel(lable: locationSetLabel)
        UIDesign().setLabel(lable: categorySetLabel)
        
        UIDesign().setLabel(lable: titleLabel)
        UIDesign().setLabel(lable: descriptionLabel)
        UIDesign().setLabel(lable: timeLabel)
        UIDesign().setLabel(lable: locationLabel)
        UIDesign().setLabel(lable: categoryLabel)
        
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
        
        UIDesign().setButtonDesign(button: joinORunjoinButton, color: UIColor.red)
    }
}

