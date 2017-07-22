//
//  DatePickerDelegate.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 25/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import Foundation

protocol DatePickerDelegate {
    func removePressed()
    func donePressed()
    func datePickerValueChanged(_ date: Date)
}
