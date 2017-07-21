
//
//  PostsVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage


class PostsVC: UIViewController {
    
    static let storyboardIdentifier = "PostsVC"
    
    var posts : [Post] = []
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            //cell set data, delegate (registered)
            //row height = cell
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var addPostButton: UIBarButtonItem!{
        didSet{
            addPostButton.target = self
            addPostButton.action = #selector(addPostButtonTapped)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func addPostButtonTapped()  {
        print("addpost button tapped")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let addPostVC = mainStoryboard.instantiateViewController(withIdentifier: "UploadPostVC")
        self.navigationController?.pushViewController(addPostVC, animated: true)
    }
    
    func fetchData() {
        
        let ref = Database.database().reference()
        ref.child("posts").observe(.childAdded, with: { (snapshot) in
            if let data = Post(snapshot: snapshot) {
                self.posts.append(data)
            }
            //sort post by lastest first
            self.posts.sort(by: {$0.timeStamp > $1.timeStamp})
            self.tableView.reloadData()
        })
    }
    
}

extension PostsVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! PostsTableViewCell
        
        let data = posts[indexPath.row]
        postsTableViewCell.titleLabel.text = data.title
        postsTableViewCell.descriptionLabel.text = data.description
        postsTableViewCell.activityImageView.sd_setImage(with: data.imageURL)
        
        return postsTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        let data = posts[indexPath.row]
        vc.getPost = data
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

