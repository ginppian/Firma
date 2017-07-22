//
//  KeyboardCapable.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 21/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardCapable: KeyboardAnimatable {
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
}

extension KeyboardCapable where Self: UIViewController {
    func registerKeyboardNotifications() {
        
        hideKeyboardWhenTappedAround()
    
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow:"), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: DissmissKeyBoard
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
