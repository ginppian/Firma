//
//  DocumentTableViewCell.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 14/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var documentHeaderView: UIView!
    @IBOutlet weak var documentNameLabel: UILabel!
    
    //Header
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var dateIniLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    // Info
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var denyLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var showLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    var delegate: DocumentCellProtocol?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func signButtonPressed(_ sender: UIButton) {
        delegate?.signDocument!(indexPath)
    }
    
    @IBAction func denyButtonPressed(_ sender: UIButton) {
        delegate?.denyDocument!(indexPath)
        
    }
    @IBAction func showButtonPressed(_ sender: UIButton) {
        delegate?.viewDocument!(indexPath)
    }
}
