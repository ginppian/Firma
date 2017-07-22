//
//  KeyTableViewCell.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 18/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class KeyTableViewCell: UITableViewCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var separatorView: UIView!
    var indexPath: IndexPath!
    var delegate: DocumentCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtonPressed(_ sender: AnyObject) {
        delegate?.editDocument(indexPath)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.deleteDocument(indexPath)
    }
    
}
