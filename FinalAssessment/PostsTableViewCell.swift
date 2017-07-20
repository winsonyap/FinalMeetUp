//
//  PostsTableViewCell.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class PostsTableViewCell: UITableViewCell {
    static let cellIdentifier = "PostsTableViewCell"
    
   var getData : Post?

    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        initCellView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)      
    }
    
    func initCellView() {
        UIDesign().setLabel(lable: titleLabel)
        UIDesign().setLabel(lable: descriptionLabel)
    }

 }
