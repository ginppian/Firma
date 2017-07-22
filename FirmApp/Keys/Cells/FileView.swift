//
//  FileView.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 21/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class FileView: UIView {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: CertProtocol?
    
    override func awakeFromNib() {
        setUpUI()
    }
    
    func setUpUI(){
        fileName.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        roundView.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        fileName.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        roundView.layer.cornerRadius = 10;
        roundView.layer.masksToBounds = true;
        
        roundView.layer.borderColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY).cgColor
        roundView.layer.borderWidth = 0.5;
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.didDeleteCer(self)
    }
}
