//
//  BaseViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //Add Logout Button
        let logOutButton: UIButton = UIButton(type: UIButtonType.custom)
        logOutButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        // Make the button text be behind the image.
        logOutButton.setImage(UIImage(named:"icon-exit"), for: UIControlState())
        logOutButton.setTitle(NSLocalizedString("BaseViewController.exit", comment: ""), for: UIControlState())
        logOutButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        logOutButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_HEADER_BUTTON
        
        logOutButton.titleEdgeInsets = UIEdgeInsetsMake(30.0, -35.0, 0.0, -35.0)
        logOutButton.imageEdgeInsets = UIEdgeInsetsMake(-5, 5.0, 10.0, -40.0)
        
        //Add Logout Button
        let backButton: UIButton = UIButton(type: UIButtonType.custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        // Make the button text be behind the image.
        backButton.setImage(UIImage(named:"icon-back"), for: UIControlState())
        backButton.setTitle(NSLocalizedString("BaseViewController.back", comment: ""), for: UIControlState())
        backButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        backButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_HEADER_BUTTON
        
        backButton.titleEdgeInsets = UIEdgeInsetsMake(30.0, -40.0, 0.0, 0.0)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(-5, -5.0, 10.0, 5.0)
        
        backButton.addTarget(self, action: #selector(BaseViewController.back), for: UIControlEvents.touchUpInside)
        
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
        
        logOutButton.addTarget(self, action: #selector(BaseViewController.logOut), for: UIControlEvents.touchUpInside)
        
        // Add Logo Header
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo-header"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logOutButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut() {
        let logOutViewController = LogOutViewController()
        //logOutViewController.view.backgroundColor = UIColor.clearColor()
//        if #available(iOS 8.0, *) {
            logOutViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        } else {
//            logOutViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//        }
        self.present(logOutViewController, animated: true, completion: nil)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
