//
//  HistoryViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 19/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//
/*
 import UIKit
 
 class HistoryViewController: BaseViewController {
 @IBOutlet weak var signedButton: UIButton!
 @IBOutlet weak var denyButton: UIButton!
 @IBOutlet weak var childView: UIView!
 
 var activeController:UIViewController? = nil
 var storyboardIDs:[String] = ["SignedViewController","DeniedViewController"]
 var viewControllers:[UIViewController] = []
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 
 //Initialize tabBar
 initializeTabBarViews()
 //Initialize buttons
 initializeButtons()
 
 setUpUI()
 
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 func setUpUI() {
 
 // Add Header
 let headerLabel:UILabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
 headerLabel.text = NSLocalizedString("HistoryViewController.title", comment: "")
 headerLabel.textAlignment = NSTextAlignment.Center
 headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
 headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
 self.navigationItem.titleView = headerLabel;
 
 }
 
 func initializeButtons() {
 signedButton.setImage(UIImage(named: "icon-sign-white"), forState: .Selected)
 signedButton.setImage(UIImage(named: "icon-sign-gray"), forState: .Normal)
 signedButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
 signedButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT), forState: .Normal)
 signedButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT_SELECTED), forState: .Selected)
 signedButton.setTitle(NSLocalizedString("HistoryViewController.signed", comment: ""), forState: .Normal)
 signedButton.setTitle(NSLocalizedString("HistoryViewController.signed", comment: ""), forState: .Selected)
 Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON_SELECTED), forState: .Selected, button: signedButton)
 Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON), forState: .Normal, button: signedButton)
 
 denyButton.setImage(UIImage(named: "icon-deny-white"), forState: .Selected)
 denyButton.setImage(UIImage(named: "icon-deny-gray"), forState: .Normal)
 denyButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT), forState: .Normal)
 denyButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT_SELECTED), forState: .Selected)
 denyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
 denyButton.setTitle(NSLocalizedString("HistoryViewController.denied", comment: ""), forState: .Normal)
 denyButton.setTitle(NSLocalizedString("HistoryViewController.denied", comment: ""), forState: .Selected)
 Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON_SELECTED), forState: .Selected, button: denyButton)
 Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON), forState: .Normal, button: denyButton)
 
 }
 
 func initializeTabBarViews() {
 let signedViewController = SignedViewController(nibName: "SignedViewController", bundle: nil)
 let deniedViewController = DeniedViewController(nibName: "DeniedViewController", bundle: nil)
 
 viewControllers.append(signedViewController)
 viewControllers.append(deniedViewController)
 
 tabButtonPressed(signedButton)
 }
 
 @IBAction func tabButtonPressed(sender: UIButton) {
 if let tempActiveController = activeController {
 self.hideContentController(tempActiveController)
 }
 
 switch sender.tag {
 case 0: //SignedViewController
 signedButton.selected = true
 denyButton.selected = false
 self.displayContentController(viewControllers[0])
 case 1: //DeniedViewController
 signedButton.selected = false
 denyButton.selected = true
 self.displayContentController(viewControllers[1])
 default:
 break;
 }
 }
 
 func displayContentController(contentController:UIViewController) {
 self.addChildViewController(contentController)
 contentController.view.frame = self.childView.frame
 self.view.addSubview(contentController.view)
 contentController.didMoveToParentViewController(self)
 self.activeController = contentController
 }
 
 func hideContentController(contentController:UIViewController) {
 contentController.willMoveToParentViewController(nil)
 contentController.view.removeFromSuperview()
 contentController.removeFromParentViewController()
 }
 
 }*/
//
//  HistoryViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 19/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {
    @IBOutlet weak var signedButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var childView: UIView!
    
    var activeController:UIViewController? = nil
    var storyboardIDs:[String] = ["SignedViewController","DeniedViewController"]
    var viewControllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Initialize tabBar
        initializeTabBarViews()
        //Initialize buttons
        initializeButtons()
        
        setUpUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        // Add Header
        let headerLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        headerLabel.text = NSLocalizedString("HistoryViewController.title", comment: "")
        headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
        headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
        self.navigationItem.titleView = headerLabel;
        
    }
    
    func initializeButtons() {
        signedButton.setImage(UIImage(named: "icon-sign-white"), for: .selected)
        signedButton.setImage(UIImage(named: "icon-sign-gray"), for: UIControlState())
        signedButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
        signedButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT), for: UIControlState())
        signedButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT_SELECTED), for: .selected)
        signedButton.setTitle(NSLocalizedString("HistoryViewController.signed", comment: ""), for: UIControlState())
        signedButton.setTitle(NSLocalizedString("HistoryViewController.signed", comment: ""), for: .selected)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON_SELECTED), forState: .selected, button: signedButton)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON), forState: UIControlState(), button: signedButton)
        
        denyButton.setImage(UIImage(named: "icon-deny-white"), for: .selected)
        denyButton.setImage(UIImage(named: "icon-deny-gray"), for: UIControlState())
        denyButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT), for: UIControlState())
        denyButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT_SELECTED), for: .selected)
        denyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
        denyButton.setTitle(NSLocalizedString("HistoryViewController.denied", comment: ""), for: UIControlState())
        denyButton.setTitle(NSLocalizedString("HistoryViewController.denied", comment: ""), for: .selected)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON_SELECTED), forState: .selected, button: denyButton)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON), forState: UIControlState(), button: denyButton)
        
    }
    
    func initializeTabBarViews() {
        let signedViewController = SignedViewController(nibName: "SignedViewController", bundle: nil)
        let deniedViewController = DeniedViewController(nibName: "DeniedViewController", bundle: nil)
        
        viewControllers.append(signedViewController)
        viewControllers.append(deniedViewController)
        
        tabButtonPressed(signedButton)
    }
    
    @IBAction func tabButtonPressed(_ sender: UIButton) {
        if let tempActiveController = activeController {
            self.hideContentController(tempActiveController)
        }
        
        switch sender.tag {
        case 0: //SignedViewController
            signedButton.isSelected = true
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSReceiptGet"), object: nil)
            denyButton.isSelected = false
            self.displayContentController(viewControllers[0])
            UserDefaults.standard.removeObject(forKey: "Denied")
            UserDefaults.standard.set("1", forKey: "Signed")
            UserDefaults.standard.synchronize()
        case 1: //DeniedViewController
            signedButton.isSelected = false
            denyButton.isSelected = true
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSReceiptGetDenied"), object: nil)
            self.displayContentController(viewControllers[1])
            UserDefaults.standard.set("1", forKey: "Denied")
            UserDefaults.standard.removeObject(forKey: "Signed")
            UserDefaults.standard.synchronize()
        default:
            break;
            
            
        }
    }
    
    func displayContentController(_ contentController:UIViewController) {
        self.addChildViewController(contentController)
        contentController.view.frame = self.childView.frame
        self.view.addSubview(contentController.view)
        contentController.didMove(toParentViewController: self)
        self.activeController = contentController
    }
    
    func hideContentController(_ contentController:UIViewController) {
        contentController.willMove(toParentViewController: nil)
        contentController.view.removeFromSuperview()
        contentController.removeFromParentViewController()
    }
    
}

