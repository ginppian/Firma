//
//  DatePicker.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 25/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class DatePicker: UIView {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var removeBarButton: UIBarButtonItem!
    var delegate: DatePickerDelegate?
    
    @IBAction func removeButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.removePressed()
    }
    
    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.donePressed()
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.datePickerValueChanged(sender.date)
    }
}
