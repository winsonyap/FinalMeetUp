//
//  uiDesign.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import Foundation
import UIKit

class UIDesign {
    
    private var gradientLayer: CAGradientLayer?
    
    func setGradientBackgroundColor(view: UIView, firstColor: UIColor, secondColor: UIColor) {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = view.bounds
        gradientLayer?.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer?.opacity = 0.7
        view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    func setLabel(lable : UILabel) {
        lable.textColor = UIColor.white
        lable.shadowColor = UIColor.gray
        lable.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func setButtonDesign(button : UIButton, color : UIColor) {
        button.layer.cornerRadius = 15.0;
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 3.0
        button.backgroundColor = UIColor.clear
        button.tintColor = color
    }
    
}
