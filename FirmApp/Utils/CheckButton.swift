//
//  CheckButton.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 15/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class CheckButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "check-checked")! as UIImage
    let uncheckedImage = UIImage(named: "check-unchecked")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState())
            } else {
                self.setImage(uncheckedImage, for: UIControlState())
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckButton.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(_ sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
