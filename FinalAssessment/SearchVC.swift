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
        keyboardAddObserver()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyboardAddObserver()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -210 // Move view 210 points upward
    }
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }

    func initSearchView() {
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
    }
}
