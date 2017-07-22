//
//  URLViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class URLViewController: BaseViewController {
    
    
    @IBOutlet weak var urlNameLabel: UILabel!
    @IBOutlet weak var urlNameTextField: UITextField!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var asignKeyButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var certKeysView: UIView!
    
    @IBOutlet var textFields: [UITextField]!
    
    var certHeight: CGFloat = 30.0
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var mode: Mode = Mode.add
    var url: URL?
    var delegate: ModalProtocolDelegate?
    
    //Variable URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        //Initialize keyboard setup
        hideKeyboardWhenTappedAround()
        
        // SetUpUI
        setUpUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        print ("function: setUpUI")
        
        textFields = [urlNameTextField,urlTextField]
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        urlNameLabel.text = NSLocalizedString("URLViewController.url_name", comment: "")
        urlNameLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        urlNameLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        urlNameTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        urlNameTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        urlNameTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        
        urlLabel.text = NSLocalizedString("URLViewController.url", comment: "")
        urlLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        urlLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        urlTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        urlTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        urlTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        
        //let headerLabel:UILabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        if (mode == Mode.edit) {
            
            //headerLabel.text = NSLocalizedString("URLViewController.modify_url", comment: "")
            addButton.setTitle(NSLocalizedString("URLViewController.save", comment: "").uppercased(), for: .normal)
            deleteButton.isHidden = false
            
            if let url = url {
                urlNameTextField.text = url.name
                urlTextField.text = url.url
                UserDefaults.standard.set(urlTextField.text!, forKey: "TemporalURL2")
                UserDefaults.standard.set(urlNameTextField.text!, forKey: "TemporalURLName2")
            }
            else{
                print ("no")
            }
            
        }
        if (mode == Mode.add ){
            //  headerLabel.text    = NSLocalizedString("URLViewController.add_url",    comment: "")
            urlLabel.text       = NSLocalizedString("URLViewController.url",        comment: "")
            
            addButton.setTitle(NSLocalizedString("URLViewController.add",           comment: "").uppercased(), for: .normal)
            asignKeyButton.setTitle(NSLocalizedString("URLViewController.asign",    comment: "").uppercased(), for: .normal)
        }
        if mode == Mode.delete {
            print ("modo Eliminar")
            UserDefaults.standard.set(urlTextField.text!, forKey: "TemporalURL3")
            UserDefaults.standard.set(urlNameTextField.text!, forKey: "TemporalURLName3")
        }
        
        // Add Logo Header
        
        /* headerLabel.textAlignment = NSTextAlignment.Center
         headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
         headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
         self.navigationItem.titleView = headerLabel;
         */
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GREEN), forState: .normal, button: addButton)
        
        asignKeyButton.setTitleColor(UIColor.white, for: .normal)
        asignKeyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_BLUE), forState: .normal, button: asignKeyButton)
        
        deleteButton.setTitle(NSLocalizedString("URLViewController.delete", comment: ""), for: .normal)
        deleteButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON_SMALL
        deleteButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: .normal)
        
        separatorView.backgroundColor = UIColor(hexString: AppConstants.Color.SEPARATOR_GRAY)
        
    }
    
    @IBAction func assignKeyButtonPressed(_ sender: UIButton) {
        print ("function: AssociateKey")
        print("entre")
        let keysViewcontroller2 = KeysViewController(nibName: "KeysViewController", bundle: nil)
        keysViewcontroller2.mode = KeyMode.assign
        keysViewcontroller2.delegate = self
        self.navigationController?.pushViewController(keysViewcontroller2, animated: true)
        print("Sali")
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if (urlNameTextField.text != "" && urlTextField.text != ""){
            
            /* Real URL validation */
            var URLPrueba = urlTextField.text!
            
            
            // if UIApplication.sharedApplication.canOpenURL(url as URL) {
            print("es una url valida")
            UserDefaults.standard.set(urlTextField.text!, forKey: "TemporalURL")
            UserDefaults.standard.set(urlNameTextField.text!, forKey: "TemporalURLName")
            UserDefaults.standard.synchronize()
            /* Saving initial value */
            
            //NSUserDefaults.standardUserDefaults().setObject(urlTextField.text!,forKey: "URLAccess")
            
            
            /* Auto-Redirecting to urlPasswordView Screen*/
            let urlPasswordViewController = URLPasswordViewController()
            
            urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            
            urlPasswordViewController.delegate = self
            urlPasswordViewController.mode = mode
            
            self.present(urlPasswordViewController, animated: true, completion: nil)
            //}
            /* else {
             print("NO es una url valida")
             /* Wrong URL, invalid Alert */
             let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Please type a valid URL", comment: ""), preferredStyle: .alert)
             alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
             self.present(alertViewController, animated: true, completion: nil)
             return
             }*/
            /**/
        }
        else {
            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Please complete both fields", comment: ""), preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        print ("function: deleteButtonPressed eliminar")
        
        /*NSUserDefaults.standardUserDefaults().setObject(urlTextField.text!, forKey: "TemporalURL3")
         NSUserDefaults.standardUserDefaults().setObject(urlNameTextField.text!, forKey: "TemporalURLName3")
         NSUserDefaults.standardUserDefaults().synchronize()
         */
        
        let urlPasswordViewController = URLPasswordViewController()
        //        if #available(iOS 8.0, *) {
        urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //        } else {
        //            urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        //        }
        
        urlPasswordViewController.delegate = self
        urlPasswordViewController.url = self.url
        urlPasswordViewController.mode = Mode.delete
        self.present(urlPasswordViewController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print ("function: textFieldShouldReturn")
        if let currentIndex = textFields.index(of: textField), currentIndex < textFields.count-1 {
            textFields[currentIndex+1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension URLViewController: ModalProtocolDelegate {
    func modalIsDismissed(_ mode: Mode) {
        print ("function: modalIsDismissed")
        delegate?.modalIsDismissed(mode);
        self.navigationController?.popViewController(animated: true)
    }
}

extension URLViewController: KeysProtocol {
    func didSelectKey(_ key: Key) {
        print ("function: didSelectKey")
        //25/03/2017
        
        //addFiles(key: key)
    }
    /*
    func addFiles(key: Key) {
        print ("function: addFiles")
        var yPosition: CGFloat = 0
        if let files = key.files {
            for (index,file) in files.enumerated() {
                let fileView = Bundle.main.loadNibNamed("FileView", owner: self, options: nil)?[0] as! FileView
                fileView.delegate = self
                fileView.tag = index
                fileView.fileName.text = file.fileName
                
                //fileView.frame = CGRectMake(0, yPosition, certKeysView.frame.size.width, certHeight);
                certKeysView.addSubview(fileView)
                
                certKeysView.frame = CGRect(x: certKeysView.frame.origin.x, y: certKeysView.frame.origin.y, width: certKeysView.frame.width, height: certKeysView.frame.height + certHeight)
                heightConstraint.constant = heightConstraint.constant + certHeight
                yPosition = yPosition + certHeight
                
            }
        }
        
    }*/
}

extension URLViewController: CertProtocol {
    func didDeleteCer(_ view: UIView) {
        print ("function: didDeleteCer")
        view.removeFromSuperview()
        if view.tag == 0 {
            for (index, fileView) in certKeysView.subviews.enumerated() {
                view.tag = index
                fileView.frame.origin.y = fileView.frame.origin.y - certHeight
            }
        }
        certKeysView.frame = CGRect(x: certKeysView.frame.origin.x, y: certKeysView.frame.origin.y, width: certKeysView.frame.width, height: certKeysView.frame.height - certHeight)
        heightConstraint.constant = heightConstraint.constant - certHeight
    }
}/*
 //
 //  URLViewController.swift
 //  SeguriData
 //
 //  Created by mikel.sanchez.local on 12/4/16.
 //  Copyright © 2016 Babel. All rights reserved.
 //
 
 import UIKit
 
 class URLViewController: BaseViewController {
 
 
 @IBOutlet weak var asignKeyButton: UIButton!
 @IBOutlet weak var urlNameLabel: UILabel!
 @IBOutlet weak var urlNameTextField: UITextField!
 @IBOutlet weak var urlLabel: UILabel!
 @IBOutlet weak var urlTextField: UITextField!
 
 @IBOutlet weak var addButton: UIButton!
 
 
 @IBOutlet weak var deleteButton: UIButton!
 @IBOutlet weak var separatorView: UIView!
 
 @IBOutlet weak var certKeysView: UIView!
 
 @IBOutlet var textFields: [UITextField]!
 
 var certHeight: CGFloat = 30.0
 
 @IBOutlet weak var heightConstraint: NSLayoutConstraint!
 
 var mode: Mode = Mode.add
 var url: URL?
 var delegate: ModalProtocolDelegate?
 
 //Variable URL
 
 override func viewDidLoad() {
 print ("function: viewDidLoad")
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 
 
 //Initialize keyboard setup
 hideKeyboardWhenTappedAround()
 
 // SetUpUI
 setUpUI()
 }
 
 override func didReceiveMemoryWarning() {
 print ("function: didReceiveMemoryWarning")
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 func setUpUI() {
 print ("function: setUpUI")
 
 textFields = [urlNameTextField,urlTextField]
 textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
 
 urlNameLabel.text = NSLocalizedString("URLViewController.url_name", comment: "")
 urlNameLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
 urlNameLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 
 urlNameTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
 urlNameTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 urlNameTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
 
 urlLabel.text = NSLocalizedString("URLViewController.url", comment: "")
 urlLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
 urlLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 
 urlTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
 urlTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 urlTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
 
 //let headerLabel:UILabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
 if (mode == Mode.edit) {
 
 //headerLabel.text = NSLocalizedString("URLViewController.modify_url", comment: "")
 addButton.setTitle(NSLocalizedString("URLViewController.save", comment: "").uppercased(), for: .normal)
 deleteButton.isHidden = false
 
 if let url = url {
 urlNameTextField.text = url.name
 urlTextField.text = url.url
 UserDefaults.standard.set(urlTextField.text!, forKey: "TemporalURL2")
 UserDefaults.standard.set(urlNameTextField.text!, forKey: "TemporalURLName2")
 }
 else{
 print ("no")
 }
 
 }
 if (mode == Mode.add ){
 //  headerLabel.text    = NSLocalizedString("URLViewController.add_url",    comment: "")
 urlLabel.text       = NSLocalizedString("URLViewController.url",        comment: "")
 
 addButton.setTitle(NSLocalizedString("URLViewController.add",           comment: "").uppercased(), for: .normal)
 asignKeyButton.setTitle(NSLocalizedString("URLViewController.asign",    comment: "").uppercased(), for: .normal)
 }
 if mode == Mode.delete {
 print ("modo Eliminar")
 UserDefaults.standard.set(urlTextField.text!, forKey: "TemporalURL3")
 UserDefaults.standard.set(urlNameTextField.text!, forKey: "TemporalURLName3")
 }
 
 // Add Logo Header
 
 /* headerLabel.textAlignment = NSTextAlignment.Center
 headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
 headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
 self.navigationItem.titleView = headerLabel;
 */
 addButton.setTitleColor(UIColor.white, for: .normal)
 addButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
 Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GREEN), forState: .normal, button: addButton)
 
 asignKeyButton.setTitleColor(UIColor.white, for: .normal)
 asignKeyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
 Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_BLUE), forState: .normal, button: asignKeyButton)
 
 deleteButton.setTitle(NSLocalizedString("URLViewController.delete", comment: ""), for: .normal)
 deleteButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON_SMALL
 deleteButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: .normal)
 
 separatorView.backgroundColor = UIColor(hexString: AppConstants.Color.SEPARATOR_GRAY)
 }
 
 
 
 @IBAction func AssociateKey(sender: UIButton) {
 print ("function: AssociateKey")
 print("entre")
 let keysViewcontroller2 = KeysViewController(nibName: "KeysViewController", bundle: nil)
 keysViewcontroller2.mode = KeyMode.assign
 keysViewcontroller2.delegate = self
 self.navigationController?.pushViewController(keysViewcontroller2, animated: true)
 print("Sali")
 }
 
 
 @IBOutlet weak var addButtonPressed: UIButton!
 @IBAction func addButtonPressed(sender: UIButton) {
 
 if (urlNameTextField.text != "" && urlTextField.text != ""){
 
 /* Real URL validation */
 var URLPrueba = urlTextField.text!
 
 
 // if UIApplication.sharedApplication.canOpenURL(url as URL) {
 print("es una url valida")
 UserDefaults.standard.set(urlTextField.text!, forKey: "TemporalURL")
 UserDefaults.standard.set(urlNameTextField.text!, forKey: "TemporalURLName")
 UserDefaults.standard.synchronize()
 /* Saving initial value */
 
 //NSUserDefaults.standardUserDefaults().setObject(urlTextField.text!,forKey: "URLAccess")
 
 
 /* Auto-Redirecting to urlPasswordView Screen*/
 let urlPasswordViewController = URLPasswordViewController()
 
 urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
 
 urlPasswordViewController.delegate = self
 urlPasswordViewController.mode = mode
 
 self.present(urlPasswordViewController, animated: true, completion: nil)
 //}
 /* else {
 print("NO es una url valida")
 /* Wrong URL, invalid Alert */
 let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Please type a valid URL", comment: ""), preferredStyle: .alert)
 alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
 self.present(alertViewController, animated: true, completion: nil)
 return
 }*/
 /**/
 }
 else {
 let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Please complete both fields", comment: ""), preferredStyle: .alert)
 alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
 self.present(alertViewController, animated: true, completion: nil)
 return
 }
 }
 
 @IBAction func deleteButtonPressed(sender: UIButton) {
 print ("function: deleteButtonPressed eliminar")
 
 /*NSUserDefaults.standardUserDefaults().setObject(urlTextField.text!, forKey: "TemporalURL3")
 NSUserDefaults.standardUserDefaults().setObject(urlNameTextField.text!, forKey: "TemporalURLName3")
 NSUserDefaults.standardUserDefaults().synchronize()
 */
 
 let urlPasswordViewController = URLPasswordViewController()
 //        if #available(iOS 8.0, *) {
 urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
 //        } else {
 //            urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
 //        }
 
 urlPasswordViewController.delegate = self
 urlPasswordViewController.url = self.url
 urlPasswordViewController.mode = Mode.delete
 self.present(urlPasswordViewController, animated: true, completion: nil)
 }
 
 func textFieldShouldReturn(textField: UITextField) -> Bool {
 print ("function: textFieldShouldReturn")
 if let currentIndex = textFields.index(of: textField), currentIndex < textFields.count-1 {
 textFields[currentIndex+1].becomeFirstResponder()
 } else {
 textField.resignFirstResponder()
 }
 return true
 }
 }
 
 extension URLViewController: ModalProtocolDelegate {
 
 func modalIsDismissed(_ mode: Mode) {
 print ("function: modalIsDismissed")
 delegate?.modalIsDismissed(mode);
 self.navigationController?.popViewController(animated: true)
 }
 }
 
 extension URLViewController: KeysProtocol {
 func didSelectKey(_ key: Key) {
 print ("function: didSelectKey")
 addFiles(key: key)
 }
 
 func addFiles(key: Key) {
 print ("function: addFiles")
 var yPosition: CGFloat = 0
 if let files = key.files {
 for (index,file) in files.enumerated() {
 let fileView = Bundle.main.loadNibNamed("FileView", owner: self, options: nil)?[0] as! FileView
 fileView.delegate = self
 fileView.tag = index
 fileView.fileName.text = file.fileName
 
 //fileView.frame = CGRectMake(0, yPosition, certKeysView.frame.size.width, certHeight);
 certKeysView.addSubview(fileView)
 
 certKeysView.frame = CGRect(x: certKeysView.frame.origin.x, y: certKeysView.frame.origin.y, width: certKeysView.frame.width, height: certKeysView.frame.height + certHeight)
 heightConstraint.constant = heightConstraint.constant + certHeight
 yPosition = yPosition + certHeight
 
 }
 }
 
 }
 }
 
 extension URLViewController: CertProtocol {
 func didDeleteCer(_ view: UIView) {
 print ("function: didDeleteCer")
 view.removeFromSuperview()
 if view.tag == 0 {
 for (index, fileView) in certKeysView.subviews.enumerated() {
 view.tag = index
 fileView.frame.origin.y = fileView.frame.origin.y - certHeight
 }
 }
 certKeysView.frame = CGRect(x: certKeysView.frame.origin.x, y: certKeysView.frame.origin.y, width: certKeysView.frame.width, height: certKeysView.frame.height - certHeight)
 heightConstraint.constant = heightConstraint.constant - certHeight
 }
 }
 */
