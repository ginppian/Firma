//
//  URLPasswordViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 13/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//
/*
import UIKit

class URLPasswordViewController:varViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var showPasswordLabel: UILabel!
    @IBOutlet weak var remindPasswordLabel: UILabel!
    @IBOutlet weak var securityLabel: UILabel!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var obsLabel: UILabel!
    @IBOutlet weak var obsTextField: UITextView!
    
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var securityHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var obsHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var modalBottomMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet var textFields: [UITextField]!
    
    
    var delegate: ModalProtocolDelegate?
    var mode: Mode = Mode.add
    var document: Document?
    var url:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set Up UI
        setUpUI()
        
        //KeyBoard Listener
        self.hideKeyboardWhenTappedAround()
    }

    func setUpUI() {
        
        textFields = [passwordField]
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        
        titleLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        titleLabel.font = AppConstants.Font.OPEN_SANS_POP_UP_TITLE
        
        if mode == Mode.add {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_add", comment: "")
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.add", comment: "").uppercased(), for: UIControlState())
        } else if mode == Mode.edit {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_modify", comment: "")
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.modify", comment: "").uppercased(), for: UIControlState())
        } else if mode == Mode.delete {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_delete1", comment: "") + " \""+url!.name + "\"" + NSLocalizedString("URLPasswordViewController.title_delete2", comment: "")
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.delete", comment: "").uppercased(), for: UIControlState())
        } else if mode == Mode.sign {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_sign", comment: "") + " \""+document!.name+"\""
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.sign", comment: "").uppercased(), for: UIControlState())
        } else {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_deny", comment: "") + " \""+document!.name+"\""
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.deny", comment: "").uppercased(), for: UIControlState())
            obsLabel.isHidden = false
            obsTextField.isHidden = false
            obsHeightContraint.constant = 130
        }
        
        passwordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        passwordLabel.text = NSLocalizedString("URLPasswordViewController.password", comment: "")
        passwordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        passwordField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        passwordField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        passwordField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        showPasswordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        showPasswordLabel.text = NSLocalizedString("URLPasswordViewController.show_password", comment: "")
        showPasswordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        remindPasswordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        remindPasswordLabel.text = NSLocalizedString("URLPasswordViewController.remind_password", comment: "")
        remindPasswordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        securityLabel.textColor = UIColor(hexString: AppConstants.Color.INFO_ERROR_RED)
        securityLabel.text = NSLocalizedString("URLPasswordViewController.security", comment: "")
        securityLabel.font = AppConstants.Font.OPEN_SANS_WARNING
        
        obsLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        obsLabel.text = NSLocalizedString("URLPasswordViewController.observations", comment: "")
        obsLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        obsTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        obsTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        obsTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        addButton.setTitleColor(UIColor.white, for: UIControlState())
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GREEN), forState: UIControlState(), button: addButton)
        addButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        cancelButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        cancelButton.setTitle(NSLocalizedString("URLPasswordViewController.cancel", comment: "").uppercased(), for: UIControlState())
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GRAY), forState: UIControlState(), button: cancelButton)
        cancelButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        securityHeightConstraint.constant = 0
        
        if UIScreen.main.bounds.height > 667 {
            if mode == Mode.deny {
                modalBottomMarginConstraint.constant = 150
            } else {
                modalBottomMarginConstraint.constant = 210
            }
        } else if UIScreen.main.bounds.height > 568 {
            if mode == Mode.deny {
                modalBottomMarginConstraint.constant = 90
            } else {
                modalBottomMarginConstraint.constant = 150
            }
        } else if UIScreen.main.bounds.height > 480 && mode != Mode.deny{
            modalBottomMarginConstraint.constant = 70
        } else {
            modalBottomMarginConstraint.constant = 22
        }
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
    
    @IBAction func showPasswordButtonPressed(_ sender: CheckButton) {
        // Hack to update cursor position
        
        let passwordTextFieldHadFocus: Bool = passwordField.isFirstResponder
        if !sender.isChecked
        {
            self.passwordField.isSecureTextEntry = false;
            self.passwordField.font = nil;
            self.passwordField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
            self.passwordField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            self.passwordField.resignFirstResponder()
        }
        else
        {
            self.passwordField.isSecureTextEntry = true;
            self.passwordField.resignFirstResponder()
        }
        if passwordTextFieldHadFocus
        {
            self.passwordField.becomeFirstResponder()
        }

    }
    
    @IBAction func remindPasswordButtonPressed(_ sender: CheckButton) {
        if !sender.isChecked {
            securityHeightConstraint.constant = 47
        } else {
            securityHeightConstraint.constant = 0
        }
            securityLabel.isHidden = sender.isChecked
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        delegate?.modalIsDismissed(mode)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let currentIndex = textFields.index(of: textField), currentIndex < textFields.count-1 {
            textFields[currentIndex+1].becomeFirstResponder()
        } else if mode == Mode.deny{
            obsTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}*/
//
//  URLPasswordViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 13/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class URLPasswordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var showPasswordLabel: UILabel!
    @IBOutlet weak var remindPasswordLabel: UILabel!
    @IBOutlet weak var securityLabel: UILabel!
    
    
    @IBOutlet weak var remindPasswordCheckButton: CheckButton!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var obsLabel: UILabel!
    @IBOutlet weak var obsTextField: UITextView!
    
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var securityHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var obsHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var modalBottomMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet var textFields: [UITextField]!
    
    var alertMessage = ""
    var delegate: ModalProtocolDelegate?
    var mode: Mode = Mode.add
    var document: Document?
    var url:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        //KeyBoard Listener
        self.hideKeyboardWhenTappedAround()
        
        if (UserDefaults.standard.object(forKey: "rememberPassword") != nil){
            if (UserDefaults.standard.object(forKey: "rememberPassword") as! String == "1"){
                let value = UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String
                passwordField.text = value
                remindPasswordLabel.text = NSLocalizedString("URLPasswordViewController.remind_password", comment: "")
            }
            else{
                securityHeightConstraint.constant = 0
                remindPasswordLabel.text = NSLocalizedString("URLPasswordViewController.remind_password", comment: "")
            }
        }
        
        
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (CallWSUserInfo) , name: "CallWSUserInfo", object: nil)
    }
    
    func setUpUI() {
        
        textFields = [passwordField]
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        
        titleLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        titleLabel.font = AppConstants.Font.OPEN_SANS_POP_UP_TITLE
        
        if mode == Mode.add {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_add", comment: "")
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.add", comment: "").uppercased(), for: UIControlState())
        } else if mode == Mode.edit {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_modify", comment: "")
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.modify", comment: "").uppercased(), for: UIControlState())
        } else if mode == Mode.delete {
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_delete1", comment: "") + " \""+url!.name + "\"" + NSLocalizedString("URLPasswordViewController.title_delete2", comment: "")
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.delete", comment: "").uppercased(), for: UIControlState())
        } else if mode == Mode.sign {
            print("sign")
            print ("document.MULTILATERAL")
            print(document!.multilateralId)
            
            print ("document name ")
            print (document!.name)
            
            UserDefaults.standard.set(document!.multilateralId, forKey: "temporalMultilateralId")
            UserDefaults.standard.set(document!.name, forKey: "temporalMultilateralIdName")
            UserDefaults.standard.synchronize()
            
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_sign", comment: "") + " \""+document!.name+"\""
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.sign", comment: "").uppercased(), for: UIControlState())
        } else {
            
            print("denied")
            print ("document.MULTILATERAL para cancelar")
            print(document!.multilateralId)
            UserDefaults.standard.set("1", forKey: "Action")
            UserDefaults.standard.set(document!.multilateralId,forKey: "temporalMultilateralIdAction")
            UserDefaults.standard.synchronize();
            
            titleLabel.text = NSLocalizedString("URLPasswordViewController.title_deny", comment: "") + " \""+document!.name+"\""
            addButton.setTitle(NSLocalizedString("URLPasswordViewController.deny", comment: "").uppercased(), for: UIControlState())
            obsLabel.isHidden = false
            obsTextField.isHidden = false
            obsHeightContraint.constant = 130
        }
        
        passwordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        passwordLabel.text = NSLocalizedString("URLPasswordViewController.password", comment: "")
        passwordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        passwordField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        passwordField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        passwordField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        showPasswordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        showPasswordLabel.text = NSLocalizedString("URLPasswordViewController.show_password", comment: "")
        showPasswordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        remindPasswordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        remindPasswordLabel.text = NSLocalizedString("URLPasswordViewController.remind_password", comment: "")
        remindPasswordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        securityLabel.textColor = UIColor(hexString: AppConstants.Color.INFO_ERROR_RED)
        securityLabel.text = NSLocalizedString("URLPasswordViewController.security", comment: "")
        securityLabel.font = AppConstants.Font.OPEN_SANS_WARNING
        
        obsLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        obsLabel.text = NSLocalizedString("URLPasswordViewController.observations", comment: "")
        obsLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        obsTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        obsTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        obsTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        addButton.setTitleColor(UIColor.white, for: UIControlState())
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GREEN), forState: UIControlState(), button: addButton)
        addButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        cancelButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        cancelButton.setTitle(NSLocalizedString("URLPasswordViewController.cancel", comment: "").uppercased(), for: UIControlState())
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GRAY), forState: UIControlState(), button: cancelButton)
        cancelButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        securityHeightConstraint.constant = 0
        
        if UIScreen.main.bounds.height > 667 {
            if mode == Mode.deny {
                modalBottomMarginConstraint.constant = 150
            } else {
                modalBottomMarginConstraint.constant = 210
            }
        } else if UIScreen.main.bounds.height > 568 {
            if mode == Mode.deny {
                modalBottomMarginConstraint.constant = 90
            } else {
                modalBottomMarginConstraint.constant = 150
            }
        } else if UIScreen.main.bounds.height > 480 && mode != Mode.deny{
            modalBottomMarginConstraint.constant = 70
        } else {
            modalBottomMarginConstraint.constant = 22
        }
        
        if (UserDefaults.standard.object(forKey: "rememberPassword") != nil){
            if (UserDefaults.standard.object(forKey: "rememberPassword") as! String == "1"){
                var value = UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String
                passwordField.text = value
                remindPasswordLabel.text = NSLocalizedString("KeyPasswordViewController.remind_password", comment: "")
                //remindPasswordLabel.text = NSLocalizedString("misc.forgetPassword", comment: "")
                remindPasswordCheckButton.isChecked = true
            }
            else{
                securityHeightConstraint.constant = 0
                remindPasswordLabel.text = NSLocalizedString("KeyPasswordViewController.remind_password", comment: "")
                remindPasswordCheckButton.isChecked = false
            }
        }
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
    
    @IBAction func showPasswordButtonPressed(_ sender: CheckButton) {
        // Hack to update cursor position
        
        let passwordTextFieldHadFocus: Bool = passwordField.isFirstResponder
        if !sender.isChecked
        {
            self.passwordField.isSecureTextEntry = false;
            self.passwordField.font = nil;
            self.passwordField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
            self.passwordField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            self.passwordField.resignFirstResponder()
        }
        else
        {
            self.passwordField.isSecureTextEntry = true;
            self.passwordField.resignFirstResponder()
        }
        if passwordTextFieldHadFocus
        {
            self.passwordField.becomeFirstResponder()
        }
        
    }
    func showAlertMessage(_ alertMessage:String){
        DispatchQueue.main.async(execute: {
            
            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
        })
        
    }
    
    func verifyIfStringExistsOnArray(_ StringToFind:String, nameOfArray: String, findRelation: Bool)->(Bool,Int){
        let list        = UserDefaults.standard.object(forKey: nameOfArray) as! String
        let array       = list.components(separatedBy: ",")
        var response    = false
        var value       = -1
        
        print ("Lista de Elementos retornados desde preferencias del usuario")
        print (list)
        
        if (array.contains(StringToFind)){
            response    = true
            if findRelation == true{
                value = array.index(of: StringToFind)!
                print ("es true")
            }
        }
        print ("retornare response: ")
        print (response)
        print ("retornare value")
        print (value)
        
        return (response,value)
    }
    
    func updateURLInformation(_ URLPosition : Int, URL:String, URLName: String, user:String, pass:String){
        
        let parameters          = [""]
        let lstTypeAuthenticate = "USUARIO_PASSWORD"
        let path                = URL+"/WS_Rest_HRV/rest/authenticate/login/"+user
        print (path)
        let request             = NSMutableURLRequest(url: Foundation.URL(string:path)!)
        let session2            = URLSession.shared
        
        var resultado           = 0
        request.httpMethod      = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let task = session2.dataTask(with: request as URLRequest , completionHandler: { data, response, error in
            print("serializacion 3")
            guard data != nil else {
                print("no data found: \(error)")
                self.showAlertMessage("misc.insertValidURL")
                return
            }
            
            do {
                print("Entre al do")
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                {
                    if (json["resultado"]as? Int != 0){
                        print("Response: \(json)")
                        let idPerson = json["idPerson"] as? Int
                        
                        print("serializacion 4")
                        UserDefaults.standard.set(idPerson,forKey: "idPerson")
                        UserDefaults.standard.set(lstTypeAuthenticate,forKey: "authType")
                        UserDefaults.standard.set(pass,forKey: "identifier")
                        UserDefaults.standard.synchronize();
                        if let domains = json["domains"] as? [[String: AnyObject]] {
                            for infoDomain in domains {
                                if let idDomain = infoDomain["idDomain"] as? Int {
                                    UserDefaults.standard.set(idDomain, forKey: "idDomain")
                                    UserDefaults.standard.synchronize();
                                }
                                if let nameDomain = infoDomain["nameDomain"] as? String {
                                    UserDefaults.standard.set( nameDomain, forKey: "nameDomain")
                                    UserDefaults.standard.synchronize();
                                    
                                }
                            }
                            self.CallWSUser(URL, URLName: URLName, edit: true, position: URLPosition)
                            /**/
                            
                        }
                    }
                    else{
                        self.showAlertMessage("misc.insertValidURL")
                    }
                    self.delegate?.modalIsDismissed(self.mode)
                    self.dismiss(animated: false, completion: nil)
                    
                }
                else {
                    
                    //swift
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                self.showAlertMessage("misc.notResponseFromServer")
                self.delegate?.modalIsDismissed(self.mode)
                self.dismiss(animated: false, completion: nil)
                
            }
        })
        task.resume()
        
    }
    @IBAction func remindPasswordButtonPressed(_ sender: CheckButton) {
        if !sender.isChecked {/*
             var passSaved = NSUserDefaults.standardUserDefaults().objectForKey("userIdentifierFirmApp") as! String
             passwordField.text = passSaved*/
            securityHeightConstraint.constant = 47
            self.obsHeightContraint.constant = 0
            if (passwordField.text! != ""){
                print (NSLocalizedString("URLPasswordViewController.remind_password", comment: ""))
                
                if (UserDefaults.standard.object(forKey: "rememberPassword") as! String != "0"){
                    
                    UserDefaults.standard.set("0", forKey: "rememberPassword")
                }
                else{
                    UserDefaults.standard.set("1", forKey: "rememberPassword")
                     
                }
                sender.checkedImage
            }
            else{
                showAlertMessage("misc.passwordNotSet")
            }
            
        } else {
            securityHeightConstraint.constant = 0
            self.obsHeightContraint.constant = 130
        }
        securityLabel.isHidden = sender.isChecked
    }
    
    func getKeysAndSend()->Int{
        print("function: getKeysAndSend")
        
        let assignedKeysList        =  UserDefaults.standard.object(forKey: "assignedKeysList") as! String
        let selectedURL             =  UserDefaults.standard.object(forKey: "SelectedURL") as! Int
        var selectedKeyPosition     =  assignedKeysList.components(separatedBy: ",")
        UserDefaults.standard.set(selectedKeyPosition[selectedURL], forKey: "selectedKeyPosition")
        UserDefaults.standard.synchronize()
        return 1
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        print("Function: addButtonPressed")
        if mode == Mode.sign{
            print ("El modo es Sign")
            if (passwordField.text! != ""){
                if (UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String == passwordField.text!){
                    var response = getKeysAndSend()
                    if (response == 1 )
                    {
                        print("Llaves validas")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSGetHash"), object: nil)
                    }
                    delegate?.modalIsDismissed(mode)
                    self.dismiss(animated: false, completion: nil)
                }
                else{
                    self.showAlertMessage("misc.wrongPassword")
                }
            }
            else{
                self.showAlertMessage("misc.passwordNotSet")
            }
        }
        if mode == Mode.deny{
            print("El modo es Deny")
            if (passwordField.text == ""){
                if (obsTextField.text! == ""){
                    self.showAlertMessage("misc.missingField")
                }
                else{
                    self.showAlertMessage("misc.passwordNotSet")
                }
                
            }
            else{
                if (UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String == passwordField.text!){
                    if(obsTextField.text! != ""){
                        UserDefaults.standard.set(obsTextField.text!, forKey: "temporalReasonForCancelation")
                        UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSCancelDocument"), object:nil )
                        self.delegate?.modalIsDismissed(self.mode)
                        self.dismiss(animated: false, completion: nil)
                    }
                    else{
                        alertMessage = "URLPasswordViewController.title_delete3"
                        self.showAlertMessage(alertMessage)
                    }
                    
                }
                else{
                    alertMessage = "misc.wrongPassword"
                    self.showAlertMessage(alertMessage)
                }
            }
            
            UserDefaults.standard.set(nil , forKey: "URLPosition")
            UserDefaults.standard.synchronize()
        }
        
        
        if mode == Mode.delete{
            print("El modo es Delete")
            if (passwordField.text! != ""){
                if (UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String == passwordField.text!){
                    
                    var position        = UserDefaults.standard.object(forKey: "rowToDelete") as! Int
                    print("Eliminar Posicion")
                    print(position)
                    var URLList         = UserDefaults.standard.object(forKey: "URL") as! String
                    print("Eliminar Posicion 1")
                    var URLNamesList    = UserDefaults.standard.object(forKey: "URLName") as! String
                    print("Eliminar Posicion 2")
                    var idsDomainList   = UserDefaults.standard.object(forKey: "URLIdDomainList") as! String
                    print("Eliminar Posicion 3")
                    var idsEmpList      = UserDefaults.standard.object(forKey: "URLIdEmpList") as! String
                    print("Eliminar Posicion 4")
                    var idsRhList       = UserDefaults.standard.object(forKey: "URLIdRhList") as! String
                    print("Eliminar Posicion 5.0")
                    var assignedKeyList = ""
                    if (UserDefaults.standard.object(forKey: "assignedKeysList") != nil) {
                        print("Eliminar Posicion 5")
                        if (UserDefaults.standard.object(forKey: "assignedKeysList") as! String != "" ){
                            print("Eliminar Posicion 5.1")
                            assignedKeyList = UserDefaults.standard.object(forKey: "assignedKeysList") as! String
                        }
                        else{
                            print("Eliminar Posicion 5.2")
                            assignedKeyList = ""
                        }
                    }
                    else{
                        print("Eliminar Posicion 6.0")
                        assignedKeyList = ""
                    }
                    print("Eliminar Posicion 7.0")
                    var URLArray        = URLList.components(separatedBy: ",")
                    var URLNamesArray   = URLNamesList.components(separatedBy: ",")
                    var idsDomainsArray = idsDomainList.components(separatedBy: ",")
                    var idsEmpArray     = idsEmpList.components(separatedBy: ",")
                    var idsRhArray      = idsRhList.components(separatedBy: ",")
                    var assignedKeysArray = assignedKeyList.components(separatedBy: ",")
                    print("Eliminar Posicion 8.0")
                    let size = URLArray.count
                    print("Eliminar Posicion 9.0")
                    if (size == 1){
                        //Send alert minimun 1 URL - Text on localizated strings
                        let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("URLPasswordViewController.almostOne", comment: ""), preferredStyle: .alert)
                        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                        self.present(alertViewController, animated: true, completion: nil)
                        return
                        
                    }
                    else{
                        print("Eliminar Posicion 10.0")
                        URLArray.remove(at: position)
                        print("Eliminar Posicion 10.1")
                        URLNamesArray.remove(at: position)
                        print("Eliminar Posicion 10.2")
                        idsDomainsArray.remove(at: position)
                        print("Eliminar Posicion 10.3")
                        idsEmpArray.remove(at: position)
                        print("Eliminar Posicion 10.4")
                        idsRhArray.remove(at: position)
                        print("Eliminar Posicion 10.5")
                        assignedKeysArray.remove(at: position)
                        print("Eliminar Posicion 11.0")
                        URLList         = URLArray.joined(separator: ",")
                        URLNamesList    =  URLNamesArray.joined(separator: ",")
                        idsDomainList   = idsDomainsArray.joined(separator: ",")
                        idsEmpList      = idsEmpArray.joined(separator: ",")
                        idsRhList       = idsRhArray.joined(separator: ",")
                        assignedKeyList = assignedKeysArray.joined(separator: ",")
                        print("Eliminar Posicion 11.0")
                        UserDefaults.standard.set(URLList, forKey:"URL")
                        UserDefaults.standard.set(URLNamesList, forKey:"URLName")
                        UserDefaults.standard.set(idsDomainList, forKey: "URLIdDomainList")
                        UserDefaults.standard.set(idsEmpList, forKey: "URLIdEmpList")
                        UserDefaults.standard.set(idsRhList, forKey: "URLIdRhList")
                        UserDefaults.standard.set(assignedKeyList, forKey: "assignedKeysList")
                        
                        UserDefaults.standard.set(nil , forKey: "URLPosition")
                        UserDefaults.standard.synchronize()
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "prepareDocumentsBeforeSet"), object: nil )
                        
                        delegate?.modalIsDismissed(mode)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
                else{
                    showAlertMessage("misc.wrongPassword")
                }
            }
            else{
                showAlertMessage("misc.passwordNotSet")
            }
        }
        if mode == Mode.add {
            print("El modo es Add")
            var URLTextField                = ""
            var URLNameTextField            = ""
            
            let userSaved = UserDefaults.standard.object(forKey: "userNameFirmApp") as! String
            let passSaved = UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String
            
            URLTextField            = UserDefaults.standard.object(forKey: "TemporalURL") as! String
            URLNameTextField        = UserDefaults.standard.object(forKey: "TemporalURLName") as! String
            
            var URLResponse     = verifyIfStringExistsOnArray(URLTextField, nameOfArray: "URL", findRelation: false)
            var nameResponse    = verifyIfStringExistsOnArray(URLNameTextField , nameOfArray: "URLName", findRelation: false)
            
            print ("Falso o Verdadero")
            print (URLTextField)
            
            //if (URLResponse.0 == false && nameResponse.0 == false){
            
            if (UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String == passwordField.text!){
                
                var URLString = URLTextField
                print ("URLPasswordViewController: Añadir")
                let user = userSaved
                let pass = passSaved
                
                let parameters          = [""]
                let lstTypeAuthenticate = "USUARIO_PASSWORD"
                let path                = URLString+"/WS_Rest_HRV/rest/authenticate/login/"+user
                print (path)
                let request             = NSMutableURLRequest(url: Foundation.URL(string:path)!)
                let session2            = URLSession.shared
                
                var resultado           = 0
                request.httpMethod      = "POST"
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                let task = session2.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    print("serializacion 3")
                    guard data != nil else {
                        print("no data found: \(error)")
                        DispatchQueue.main.async(execute: {
                            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("misc.notResponseFromServer", comment: ""), preferredStyle: .alert)
                            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                            
                            self.present(alertViewController, animated: true, completion: nil)
                            return
                        })
                        
                        return
                    }
                    
                    do {
                        print("Entre al do")
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        {
                            if (json["resultado"]as? Int != 0){
                                print("Response: \(json)")
                                let idPerson = json["idPerson"] as? Int
                                
                                print("serializacion 4")
                                UserDefaults.standard.set(idPerson,forKey: "idPerson")
                                UserDefaults.standard.set(lstTypeAuthenticate,forKey: "authType")
                                UserDefaults.standard.set(pass,forKey: "identifier")
                                UserDefaults.standard.synchronize();
                                if let domains = json["domains"] as? [[String: AnyObject]] {
                                    for infoDomain in domains {
                                        if let idDomain = infoDomain["idDomain"] as? Int {
                                            UserDefaults.standard.set(idDomain, forKey: "idDomain")
                                            UserDefaults.standard.synchronize();
                                        }
                                        if let nameDomain = infoDomain["nameDomain"] as? String {
                                            UserDefaults.standard.set( nameDomain, forKey: "nameDomain")
                                            UserDefaults.standard.synchronize();
                                            
                                        }
                                    }
                                    self.CallWSUser(URLTextField, URLName: URLNameTextField, edit:false, position: -1)
                                }
                                
                            }
                            else{
                                print ("no se ha encontrado ningun registro que coincida")
                                DispatchQueue.main.async(execute: {
                                    //TODO Message
                                    let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("No username valid on this server.", comment: ""), preferredStyle: .alert)
                                    alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                                    
                                    self.present(alertViewController, animated: true, completion: nil)
                                    return })
                            }
                        } else {
                            //swift
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    } catch let parseError {
                        //print(parseError)// Log the error thrown by `JSONObjectWithData`
                        //TODO Message
                        DispatchQueue.main.async(execute: {
                            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Not valid Server:                             " + URLString + " Try again" + user, comment: ""), preferredStyle: .alert)
                            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                            self.present(alertViewController, animated: true, completion: nil)
                            return
                        })
                    }
                })
                task.resume()
                delegate?.modalIsDismissed(mode)
                self.dismiss(animated: false, completion: nil)
                
            }
            else{
                print ("no coincide las contraseña")
                //TODO Message
                let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Wrong password, try again", comment: ""), preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                self.present(alertViewController, animated: true, completion: nil)
                return
            }
            /* }
             else {
             if URLResponse.0 == true {
             alertMessage = "URLPasswordViewController.URLExists"
             showAlertMessage(alertMessage)
             }
             if nameResponse.0 == true {
             alertMessage = "URLPasswordViewController.URLNameExists"
             showAlertMessage(alertMessage)
             }
             }*/
            
        }
        if (mode == Mode.edit){
            if (passwordField.text! != ""){
                if (UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String == passwordField.text!){
                    print("modo editar activado boton")
                    
                    var URLTextField         = ""
                    var URLNameTextField     = ""
                    var choosedKey           = -1
                    
                    let userSaved = UserDefaults.standard.object(forKey: "userNameFirmApp") as! String
                    let passSaved = UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String
                    
                    URLTextField            = UserDefaults.standard.object(forKey: "TemporalURL") as! String
                    URLNameTextField        = UserDefaults.standard.object(forKey: "TemporalURLName") as! String
                    
                    var URLResponse     = verifyIfStringExistsOnArray(URLTextField, nameOfArray: "URL", findRelation: true)
                    var nameResponse    = verifyIfStringExistsOnArray(URLNameTextField , nameOfArray: "URLName", findRelation: true)
                    
                    var ActualURLTextField          = UserDefaults.standard.object(forKey: "TemporalURL") as! String
                    var ActualURLNameTextField      = UserDefaults.standard.object(forKey: "TemporalURLName") as! String
                    var position                    = UserDefaults.standard.object(forKey: "rowToUpdate") as! Int
                    if (UserDefaults.standard.object(forKey: "temporalChoosedKey") != nil){
                        print("Es diferente de nil")
                        choosedKey                  = UserDefaults.standard.object(forKey: "temporalChoosedKey") as! Int
                    }
                    else{
                        print("Es nil")
                    }
                    print("coincidencias url:")
                    print(URLResponse.0)
                    print("coincidencias name:")
                    print(nameResponse.0)
                    //if (URLResponse.0 == false &&  nameResponse.0 == false){
                    if (UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String == passwordField.text!){
                        self.updateURLInformation(position, URL: URLTextField , URLName :URLNameTextField, user: userSaved, pass: passSaved)
                    }
                        
                    else{
                        showAlertMessage("misc.wrongPassword")
                    }
                    delegate?.modalIsDismissed(mode)
                    self.dismiss(animated: false, completion: nil)
                    //}
                    //else {
                    // showAlertMessage("URLPasswordViewController.URLNameExists")
                    //}
                }
                else{
                    showAlertMessage("misc.wrongPassword")
                }
            }
                
            else{
                showAlertMessage("misc.passwordNotSet")
            }
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let currentIndex = textFields.index(of: textField), currentIndex < textFields.count-1 {
            textFields[currentIndex+1].becomeFirstResponder()
        } else if mode == Mode.deny{
            obsTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func CallWSUser(_ URL: String, URLName: String, edit: Bool, position: Int){
        
        var changeObject = LoginViewController()
        print("ELI ")
        print ("call ws user")
        
        var counter = 0
        var path       = ""
        let session     = URLSession.shared
        let idDomain    = UserDefaults.standard.object(forKey: "idDomain") as! Int
        let idPerson    = UserDefaults.standard.object(forKey: "idPerson") as! Int
        let authType    = UserDefaults.standard.object(forKey: "authType") as! String
        let pass        = UserDefaults.standard.object(forKey: "identifier") as! String
        
        let JSONObject  =  "{\"idDomain\":\(idDomain),\"idPerson\":\(idPerson),\"autType\":\(authType),\"password\":\(pass)}"
        
        print ("estos son los parametros")
        print(JSONObject)
        path = URL+"/WS_Rest_HRV/rest/authenticate/user"
        print ("Intentando loguear a :")
        print (path)
        print("ELI LOGUEO")
        let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = JSONObject.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard data != nil else {
                
                let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Not response from server. Please try again later", comment: ""), preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                
                self.present(alertViewController, animated: true, completion: nil)
                return
                    
                    
                    print("no data found: \(error)")
                return
            }
            
            do {
                print ("entre 1er do")
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                {
                    if (json["resultado"]as? Int != 0){
                        
                        print("Response: \(json)")
                        var JoinedString = ""
                        var idRhEmp = json["idRh"]!
                        
                        UserDefaults.standard.set(idRhEmp, forKey: "idRhEmp")
                        UserDefaults.standard.synchronize();
                        print ("1")
                        var URLList    = UserDefaults.standard.object(forKey: "URL") as! String
                        print ("2")
                        var URLArray   = URLList.components(separatedBy: ",")
                        if (edit == false){
                            print ("3")
                            URLArray.append(String(URL))
                        }
                        else{
                            print ("4")
                            URLArray[position] = URL
                        }
                        print ("5")
                        JoinedString    = URLArray.joined(separator: ",")
                        UserDefaults.standard.set(JoinedString, forKey:"URL")
                        
                        var URLNameList    = UserDefaults.standard.object(forKey: "URLName") as! String
                        var URLNameArray   = URLNameList.components(separatedBy: ",")
                        if (edit == false){
                            URLNameArray.append(URLName)}
                        else{ URLNameArray[position] = URLName}
                        
                        JoinedString    = URLNameArray.joined(separator: ",")
                        UserDefaults.standard.set(JoinedString, forKey:"URLName")
                        
                        if (UserDefaults.standard.object(forKey: "URLIdEmpList") == nil){
                            UserDefaults.standard.set(String(idPerson), forKey:"URLIdEmpList")
                        }
                        else{
                            var URLIdEmpList    = UserDefaults.standard.object(forKey: "URLIdEmpList") as! String
                            var URLIdEmpArray   = URLIdEmpList.components(separatedBy: ",")
                            if (edit == false){URLIdEmpArray.append(String(idPerson))}
                            else{URLIdEmpArray[position] = String(idPerson)}
                            var JoinedString    = URLIdEmpArray.joined(separator: ",")
                            UserDefaults.standard.set(JoinedString, forKey:"URLIdEmpList")
                        }
                        
                        if (UserDefaults.standard.object(forKey: "URLIdDomainList") == nil){
                            UserDefaults.standard.set(String(idDomain), forKey:"URLIdDomainList")
                        }
                        else {
                            var URLIdDomainList     = UserDefaults.standard.object(forKey: "URLIdDomainList") as! String
                            var URLIdDomainArray    = URLIdDomainList.components(separatedBy: ",")
                            if (edit == false){URLIdDomainArray.append(String(idDomain))}
                            else{URLIdDomainArray[position] = String(idDomain)}
                            var JoinedString        = URLIdDomainArray.joined(separator: ",")
                            UserDefaults.standard.set(JoinedString, forKey: "URLIdDomainList")
                        }
                        if (UserDefaults.standard.object(forKey: "URLIdRhList") == nil){
                            UserDefaults.standard.set(String(describing: idRhEmp), forKey:"URLIdRhList")
                        }
                        else{
                            var URLIdRhList     = UserDefaults.standard.object(forKey: "URLIdRhList") as! String
                            var URLIdRhArray    = URLIdRhList.components(separatedBy: ",")
                            if (edit == false){ URLIdRhArray.append(String(describing: idRhEmp))}
                            else{URLIdRhArray[position] = String(describing: idRhEmp)}
                            var JoinedString    = URLIdRhArray.joined(separator: ",")
                            UserDefaults.standard.set(JoinedString, forKey: "URLIdRhList")
                        }
                        
                        var temporalAssignedKey :String = "-1"
                        if (UserDefaults.standard.object(forKey: "temporalAssignedKey") != nil){
                            temporalAssignedKey = UserDefaults.standard.string(forKey: "temporalAssignedKey")!
                            print("temporalAssignedKey swift 3")
                            print(temporalAssignedKey)
                        }
                        if (UserDefaults.standard.object(forKey: "URL") != nil){
                            
                            var assignedKeysList = UserDefaults.standard.object(forKey: "assignedKeysList") as! String
                            var assignedKeysArray = assignedKeysList.components(separatedBy: ",")
                            
                            if (edit == false){ assignedKeysArray.append(temporalAssignedKey)}
                            else{
                                
                                if (UserDefaults.standard.object(forKey: "temporalAssignedKey") != nil){assignedKeysArray[position] = temporalAssignedKey}
                            }
                            var JoinedString    = assignedKeysArray.joined(separator: ",")
                            
                            UserDefaults.standard.set(JoinedString, forKey: "assignedKeysList")
                            print ("Asi quedo la lista de llaves asignadas")
                            print (JoinedString)
                        }
                        else {
                            UserDefaults.standard.set(temporalAssignedKey, forKey:"assignedKeysList")
                        }
                        UserDefaults.standard.removeObject(forKey: "temporalChoosedKey")
                        UserDefaults.standard.removeObject(forKey:"temporalAssignedKey")
                        UserDefaults.standard.removeObject(forKey: "URLPosition")
                        UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "prepareDocumentsBeforeSet"), object: nil )
                    }
                    else{
                        UserDefaults.standard.set(nil, forKey: "temporalChoosedKey")
                        UserDefaults.standard.synchronize()
                        
                        DispatchQueue.main.async(execute: {
                            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("No username valid on this server, Please verify your login credentials and try again", comment: ""), preferredStyle: .alert)
                            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                            
                            self.present(alertViewController, animated: true, completion: nil)
                            return
                        })
                    }
                } else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                print("ELI error con json")
                DispatchQueue.main.async(execute: {
                    let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("Error with Server", comment: ""), preferredStyle: .alert)
                    alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                    
                    self.present(alertViewController, animated: true, completion: nil)
                    return
                })
            }
            
        })
        
        task.resume()
    }
    
    
}

