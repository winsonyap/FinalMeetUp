//
//  SearchVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 20/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchView()
    }
    
    func initSearchView() {
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
    }
}
