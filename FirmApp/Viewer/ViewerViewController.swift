//
//  ViewerViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 19/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class ViewerViewController: BaseViewController {
    
    var document: Document?
    
    @IBOutlet weak var borderLineView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(redrawFile) , name: NSNotification.Name(rawValue: "RedrawFile"), object: nil)
        // Do any additional setup after loading the view.
        
        setUpUI()
        if let document = document {
            // Add Header
            let headerLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            headerLabel.text = document.name
            headerLabel.textAlignment = NSTextAlignment.center
            headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
            headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
            self.navigationItem.titleView = headerLabel;
            
            //Example of base64 data encoded
            
            if ( UserDefaults.standard.object(forKey: "multilateralIdBase64Document") != nil)
            {
                let base64String = UserDefaults.standard.string(forKey: "multilateralIdBase64Document")
                
                let d = Data(base64Encoded: base64String!, options: .ignoreUnknownCharacters)
                //print (d)
                print("transforme")
                self.webView.load(d!, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: Foundation.URL(fileURLWithPath: ""))
                
            }
        }
    }
    
    func redrawFile(){
        if let document = document {
            // Add Header
            let headerLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            headerLabel.text = document.name
            headerLabel.textAlignment = NSTextAlignment.center
            headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
            headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
            self.navigationItem.titleView = headerLabel;
            
            if ( UserDefaults.standard.object(forKey: "multilateralIdBase64Document") != nil)
            {
                let base64String = UserDefaults.standard.object(forKey: "multilateralIdBase64Document") as! String
                
                let d = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)
                print (d)
                
                self.webView.load(d!, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: Foundation.URL(fileURLWithPath: ""))
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        borderLineView.backgroundColor = UIColor(hexString: AppConstants.Color.SEPARATOR_GRAY)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
