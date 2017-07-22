//
//  KeyboardAnimatable.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 21/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardAnimatable {
    
}

extension KeyboardAnimatable where Self: UIViewController {
    func performKeyboardShowFullViewAnimation(withKeyboardHeight height: CGFloat, andDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: -height + 167, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
    }
    
    func performKeyboardHideFullViewAnimation(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
    }
}
