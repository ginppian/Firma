//
//  MainViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var childView: UIView!
    
    @IBOutlet weak var documentsButton: UIButton!
    @IBOutlet weak var keysButton: UIButton!
    
    @IBOutlet weak var borderLineView: UIView!
    
    var activeController:UIViewController? = nil
    var storyboardIDs:[String] = ["SplashViewController","LoginViewController"]
    var viewControllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Initialize tabBar
        initializeTabBarViews()
        //Initialize buttons
        initializeButtons()
        
        //createBadge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeTabBarViews() {
        let documentsViewController = DocumentsViewController(nibName: "DocumentsViewController", bundle: nil)
        let keysViewController = KeysViewController(nibName: "KeysViewController", bundle: nil)
        
        viewControllers.append(documentsViewController)
        viewControllers.append(keysViewController)
        
        tabButtonPressed(documentsButton)
    }
    
    func initializeButtons() {
        documentsButton.setImage(UIImage(named: "icon-document-white"), for: .selected)
        documentsButton.setImage(UIImage(named: "icon-document-gray"), for: UIControlState())
        documentsButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT), for: UIControlState())
        documentsButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT_SELECTED), for: .selected)
        documentsButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
        documentsButton.setTitle(NSLocalizedString("MainViewController.documents", comment: ""), for: UIControlState())
        documentsButton.setTitle(NSLocalizedString("MainViewController.documents", comment: ""), for: .selected)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON_SELECTED), forState: .selected, button: documentsButton)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON), forState: UIControlState(), button: documentsButton)
        //let documentsBadge = SwiftBadge()
        
        //configureBadge(documentsBadge)
        //documentsBadge.text = "4"
        //documentsButton.addSubview(documentsBadge)
        //positionBadge(documentsBadge,button: documentsButton)
        
        keysButton.setImage(UIImage(named: "icon-key-white"), for: .selected)
        keysButton.setImage(UIImage(named: "icon-key-gray"), for: UIControlState())
        keysButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT), for: UIControlState())
        keysButton.setTitleColor(UIColor(hexString: AppConstants.Color.TAB_TEXT_SELECTED), for: .selected)
        keysButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
        keysButton.setTitle(NSLocalizedString("MainViewController.keys", comment: ""), for: UIControlState())
        keysButton.setTitle(NSLocalizedString("MainViewController.keys", comment: ""), for: .selected)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON_SELECTED), forState: .selected, button: keysButton)
        Utils.setColor(UIColor(hexString: AppConstants.Color.TAB_BUTTON), forState: UIControlState(), button: keysButton)
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
    
    @IBAction func tabButtonPressed(_ sender: UIButton) {
        if let tempActiveController = activeController {
            self.hideContentController(tempActiveController)
        }

        switch sender.tag {
        case 0: //DocumentsViewController
            documentsButton.isSelected = true
            keysButton.isSelected = false
            self.displayContentController(viewControllers[0])
        case 1: //KeysViewController
            documentsButton.isSelected = false
            keysButton.isSelected = true
            self.displayContentController(viewControllers[1])
        default:
            break;
        }
    }
    
    fileprivate func configureBadge(_ badge: SwiftBadge) {
        // Insets
        badge.insets = CGSize(width: 3, height: 3)
        
        // Font
        badge.font = UIFont(name: badge.font!.fontName, size: CGFloat(9))
        
        // Text color
        badge.textColor = UIColor.white
        
        // Badge color
        badge.badgeColor = UIColor(hexString: AppConstants.Color.BADGE)
        
        // Shadow
//        badge.shadowOpacityBadge = 0.0
//        badge.shadowOffsetBadge = CGSize(width: 0, height: 0)
//        badge.shadowRadiusBadge = 0.0
//        badge.shadowColorBadge = UIColor.greenColor()
        
        // No shadow
        badge.shadowOpacityBadge = 0
        
        // Border width and color
//        badge.borderWidth = 0.1
//        badge.borderColor = UIColor.whiteColor()
    }
    
    fileprivate func positionBadge(_ badge: UIView, button: UIButton) {
        badge.translatesAutoresizingMaskIntoConstraints = false

        let badgeDictionary = ["button" : button, "badgeView" : badge]
                button.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[badgeView]-4-|", options: [], metrics: nil, views: badgeDictionary))
                button.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[badgeView]", options: [], metrics: nil, views: badgeDictionary))
    }
}
