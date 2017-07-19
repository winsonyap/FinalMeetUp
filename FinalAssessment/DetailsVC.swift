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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var joinORunjoinButton: UIButton!{
        didSet{
            joinORunjoinButton.addTarget(self, action: #selector(joinUnJoinButtonTapped), for: .touchUpInside)
        }
    }
  
    
    var posts : [Post] = []
    //getPost from the table cell directly bring to detail
    var getPost : Post?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = getPost?.title
        descriptionLabel.text = getPost?.description
        imageView.sd_setImage(with:getPost?.imageURL)
        timeLabel.text = getPost?.time
        locationLabel.text = getPost?.location
        categoryLabel.text = getPost?.category
    }
    
    func joinUnJoinButtonTapped()  {
        
        
    }
   
    }

