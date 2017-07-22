//
//  URLTableViewCell.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 21/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class URLTableViewCell: UITableViewCell {

    @IBOutlet weak var urlView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var remainingLabel: UILabel!
    
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
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        delegate?.editDocument(indexPath)
    }
    
    @IBAction func deleteButtontapped(_ sender: UIButton) {
        delegate?.deleteDocument(indexPath)
    }
}
