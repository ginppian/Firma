//
//  HistoryDocExpTableViewCell.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 20/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//
/*
 import UIKit
 
 class HistoryDocExpTableViewCell: UITableViewCell {
 
 @IBOutlet weak var nameLabel: UILabel!
 @IBOutlet weak var dateIniLabel: UILabel!
 @IBOutlet weak var dateEndLabel: UILabel!
 @IBOutlet weak var urlName: UILabel!
 @IBOutlet weak var sizeLabel: UILabel!
 @IBOutlet weak var showLabel: UILabel!
 @IBOutlet weak var showButton: UIButton!
 
 @IBOutlet weak var calendarImage: UIImageView!
 @IBOutlet weak var obsLabel: UILabel!
 
 var delegate: HistoryCellProtocol?
 var indexPath: NSIndexPath!
 
 override func awakeFromNib() {
 super.awakeFromNib()
 // Initialization code
 }
 
 override func setSelected(selected: Bool, animated: Bool) {
 super.setSelected(selected, animated: animated)
 
 // Configure the view for the selected state
 }
 
 @IBAction func showButtonPressed(sender: UIButton) {
 delegate?.viewDocument(indexPath)
 }
 
 }*/
//
//  HistoryDocExpTableViewCell.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 20/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class HistoryDocExpTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateIniLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var urlName: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var obsLabel: UILabel!
    
    var delegate: HistoryCellProtocol?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func showButtonPressed(_ sender: UIButton) {
        //NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "PDFCall")
        //print("show not expanded")
        print(indexPath.row)
        
        if(UserDefaults.standard.object(forKey: "Denied") != nil){
            print("denied")
            var deniedMultilateralIdsList = UserDefaults.standard.object(forKey: "deniedMultilateralIds") as! String
            print ("lista de documentos denegados")
            print (deniedMultilateralIdsList)
            var deniedMultilateralIdsArray = deniedMultilateralIdsList.components(separatedBy: ",")
            var temporalMultilateralId = deniedMultilateralIdsArray[indexPath.row]
            print("idTemporal")
            UserDefaults.standard.set(temporalMultilateralId, forKey: "temporalMultilateralId")
            UserDefaults.standard.synchronize()
            
            //****************************************************
            var urlList = UserDefaults.standard.object(forKey: "deniedMultilateralIdsURLPosition") as! String
            var urlIdsArray = urlList.components(separatedBy: ",")
            var idURL = urlIdsArray[indexPath.row]
            print ("lista de ids")
            print (urlIdsArray)
            print("idSeleccionado")
            print(idURL)
            //****************************************************
            UserDefaults.standard.set(String(describing: idURL), forKey: "URLSelected")
            UserDefaults.standard.synchronize()
            
            
            //delegate?.viewDocument(indexPath)
        }
            
        else{
            print("signed")
            var signedMultilateralIdsList = UserDefaults.standard.object(forKey: "signedMultilateralIds") as! String
            var signedMultilateralIdsArray = signedMultilateralIdsList.components(separatedBy: ",")
            var temporalMultilateralId = signedMultilateralIdsArray[indexPath.row]
            print ("lista de documentos firmados")
            print (signedMultilateralIdsList)
            
            var urlList = UserDefaults.standard.object(forKey: "signedMultilateralIdsURLPosition") as! String
            var urlIdsArray = urlList.components(separatedBy: ",")
            var idURL = urlIdsArray[indexPath.row]
            print ("lista de ids")
            print (urlIdsArray)
            print("idSeleccionado")
            print(idURL)
            UserDefaults.standard.set(temporalMultilateralId, forKey: "temporalMultilateralId")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(String(describing: idURL), forKey: "URLSelected")
            UserDefaults.standard.synchronize()
            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSGetDocument"), object: nil)
        delegate?.viewDocument(indexPath)    }
    
}

