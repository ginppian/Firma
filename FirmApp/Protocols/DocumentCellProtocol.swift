//
//  DocumentCellProtocol.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 18/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import Foundation

@objc protocol DocumentCellProtocol {
    @objc optional func signDocument(_ indexPath: IndexPath)
    @objc optional func denyDocument(_ indexPath: IndexPath)
    @objc optional func viewDocument(_ indexPath: IndexPath)
    func editDocument(_ indexPath: IndexPath)
    func deleteDocument(_ indexPath: IndexPath)
}
