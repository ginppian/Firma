//
//  SplashViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var splashTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // SetUpUI
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Wait 2 seconds until checkAccess is executed.
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(SplashViewController.checkAccess), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // setUpUI Method
    func setUpUI() {
        splashTextLabel.font = AppConstants.Font.OPEN_SANS_SPLASH_TITLE
        splashTextLabel.text = NSLocalizedString("SplashViewController.text", comment: "")
    }
    
    // MARK: Check Acces control
    func checkAccess() {
        //let user = NSUserDefaults.standardUserDefaults().stringForKey(AppConstants.USER)
        //let password = NSUserDefaults.standardUserDefaults().stringForKey(AppConstants.PASSWORD)
        
        // If user and password are stored in the app, make the loggin automatically, else go to
        if (UserDefaults.standard.object(forKey: "URL") == nil){
            print("no se encontro nada url")
            let l = setURLConfiguration(nibName: "setURLConfiguration", bundle: nil)
            UIApplication.shared.keyWindow?.rootViewController = l
            self.view.window?.rootViewController!.present(l, animated: true, completion: nil)
            //Make Loggin
            /* let l = SetURL(nibName: "SetURL", bundle: nil)
             UIApplication.sharedApplication().keyWindow?.rootViewController = l
             self.view.window?.rootViewController!.presentViewController(l, animated: true, completion: nil)*/
            
        } else {
            
            
            // Go to login Screen
            
            let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            
            self.view.window?.rootViewController!.present(loginViewController, animated: true, completion: nil)
        }
    }
}
