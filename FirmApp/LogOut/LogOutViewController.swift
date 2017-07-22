//
//  LogOutViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class LogOutViewController: UIViewController {

    @IBOutlet weak var textAdviceLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }

    func setUpUI() {
        textAdviceLabel.font = AppConstants.Font.OPEN_SANS_POP_UP_TITLE
        textAdviceLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        textAdviceLabel.text = NSLocalizedString("LogOutViewController.advice", comment: "")
        
        logOutButton.setTitle(NSLocalizedString("LogOutViewController.log_out", comment: "").uppercased(), for: UIControlState())
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GREEN), forState: UIControlState(), button: logOutButton)
        logOutButton.setTitleColor(UIColor.white, for: UIControlState())
        logOutButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        cancelButton.setTitle(NSLocalizedString("LogOutViewController.cancel", comment: "").uppercased(), for: UIControlState())
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GRAY), forState: UIControlState(), button: cancelButton)
        cancelButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        cancelButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transparentBackgroundView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7)
        }) 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transparentBackgroundView.backgroundColor = UIColor.clear
        }) 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logOutButtonAction(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
