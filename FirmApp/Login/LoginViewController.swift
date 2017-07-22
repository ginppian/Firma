//
//  LoginViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Colaborated by Elizabeth Hernández Morales as Back-End developer
//
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit
import Dispatch

class LoginViewController: UIViewController, KeyboardCapable {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var showPasswordLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sessionWarningLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var showPasswordButton: CheckButton!
    @IBOutlet weak var sessionButton: CheckButton!
    
    @IBOutlet var textFields: [UITextField]!
    
    var accountCounter = 0
    var user = ""
    var pass = ""
    
    @IBOutlet weak var sessionWarningHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,selector: #selector(CallWSUser),name: NSNotification.Name(rawValue: "CallWSLoginFinished") ,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(setUpUI),name: NSNotification.Name(rawValue: "setUpUI") ,object: nil)
        UserDefaults.standard.removeObject(forKey: "accountCounter")
        UserDefaults.standard.removeObject(forKey: "URLIdDomainList")
        UserDefaults.standard.removeObject(forKey: "URLIdEmpList")
        UserDefaults.standard.removeObject(forKey: "URLIdRhList")
        print ("Cleaning cer and key")
        UserDefaults.standard.removeObject(forKey:  "temporalCerFile")
        UserDefaults.standard.removeObject(forKey:  "temporalKeyFile")
        UserDefaults.standard.removeObject(forKey: "signedMultilateralIds")
        UserDefaults.standard.removeObject(forKey: "deniedMultilateralIds")
        UserDefaults.standard.set("false", forKey: "makeComparison")
        UserDefaults.standard.set(String(describing:2), forKey: "URLIdEmpList")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Set up Strings
        setUpUI()
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        performKeyboardShowFullViewAnimation(withKeyboardHeight: keyboardHeight, andDuration: animationDuration)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        performKeyboardHideFullViewAnimation(withDuration: animationDuration)
    }
    
    func setUpUI() {
        textFields = [userTextField,passwordTextField]
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        userLabel.text = NSLocalizedString("LoginViewController.user", comment: "")
        userLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        userLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        
        userTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        userTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        passwordLabel.text = NSLocalizedString("LoginViewController.password", comment: "")
        passwordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        passwordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        passwordTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        passwordTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        //passwordTextField.defaultTextAttributes = [NSFontAttributeName: self.passwordTextField.font!, NSForegroundColorAttributeName: passwordTextField.textColor!];
        
        
        showPasswordLabel.text = NSLocalizedString("LoginViewController.show_characters", comment: "")
        showPasswordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        showPasswordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        sessionLabel.text = NSLocalizedString("LoginViewController.session", comment: "")
        sessionLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        sessionLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        sessionWarningLabel.text = NSLocalizedString("LoginViewController.session_warn", comment: "")
        sessionWarningLabel.font = AppConstants.Font.OPEN_SANS_WARNING
        sessionWarningLabel.textColor = UIColor(hexString: AppConstants.Color.INFO_ERROR_RED)
        
        if sessionButton.isChecked {
            sessionWarningHeightConstraint.constant = 45
        } else {
            sessionWarningHeightConstraint.constant = 0
        }
        if (UserDefaults.standard.object(forKey: "rememberPassword") != nil){
            if (UserDefaults.standard.object(forKey: "rememberPassword") as! String != "0"){
                sessionWarningHeightConstraint.constant = 45
                sessionButton.isChecked = true
                /*  Checking if username and password were previously saved */
                if UserDefaults.standard.object(forKey: "userNameFirmApp") == nil{
                    
                }
                else {
                    let user = UserDefaults.standard.string(forKey: "userNameFirmApp")
                    let identifier = UserDefaults.standard.string(forKey: "userIdentifierFirmApp")
                    userTextField.text      =  user
                    userTextField.endEditing(true)
                    passwordTextField.text  =  identifier
                    passwordTextField.endEditing(true)
                }
            }
                
            else{
                sessionWarningHeightConstraint.constant = 0
                sessionButton.isChecked = false
            }
        }
        else{
            sessionWarningHeightConstraint.constant = 0
            sessionButton.isChecked = false
        }
        if !sessionButton.isChecked {
            showPasswordButton.isChecked = false
            userTextField.text = ""
            passwordTextField.text = ""
        }
        
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GREEN), forState: UIControlState(), button: logInButton)
        logInButton.setTitle(NSLocalizedString("LoginViewController.log_in", comment: "").uppercased(), for: UIControlState())
        logInButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        logInButton.isEnabled = true
        
        userTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        passwordTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        logInButton.backgroundColor = UIColor(hexString: AppConstants.Color.BUTTON_GREEN)
        
    }
    
    func showAlertMessage(_ alertMessage:String){
        DispatchQueue.main.async(execute: {
            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
        })
    }
    
    @IBAction func showPasswordButtonPressed(_ sender: CheckButton) {
        
        let passwordTextFieldHadFocus: Bool = passwordTextField.isFirstResponder
        if !sender.isChecked
        {
            self.passwordTextField.isSecureTextEntry = false;
            self.passwordTextField.font = nil;
            self.passwordTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
            self.passwordTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            self.passwordTextField.resignFirstResponder()
        }
        else
        {
            self.passwordTextField.isSecureTextEntry = true;
            self.passwordTextField.resignFirstResponder()
        }
        if passwordTextFieldHadFocus
        {
            self.passwordTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func sessionButtonPressed(_ sender: CheckButton) {
        if !sender.isChecked {
            sessionWarningHeightConstraint.constant = 45
        } else {
            sessionWarningHeightConstraint.constant = 0
        }
    }
    
    @IBAction func loginActionPressed(_ sender: UIButton) {
        if (userTextField.text != "" && passwordTextField.text != ""){
            
            self.user = userTextField.text!
            self.pass = passwordTextField.text!
            
            UserDefaults.standard.set(userTextField.text!,forKey: "userNameFirmApp")
            UserDefaults.standard.set(passwordTextField.text!,forKey: "userIdentifierFirmApp")
            UserDefaults.standard.synchronize()
            getAccountFullData()
            
            if sessionButton.isChecked {
                UserDefaults.standard.set("1", forKey: "rememberPassword")
                UserDefaults.standard.synchronize()
            }
            else{
                UserDefaults.standard.set("0", forKey: "rememberPassword")
                UserDefaults.standard.synchronize()
            }
        }
        
        else{
            if (userTextField.text == "" && passwordTextField.text == ""){
                
                self.showAlertMessage("LoginViewController.error_user_pass")
            }
            else{
                if (userTextField.text == ""){
                    self.showAlertMessage("LoginViewController.error_user")
                }
                else{
                    self.showAlertMessage("LoginViewController.error_pass")
                }
            }
            self.showAlertMessage("LoginViewController.error_user_pass")
            logInButton.isUserInteractionEnabled = false
        }
    }
    func moveToDocumentsScreen(){
        DispatchQueue.main.async {
            let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
            let navigationViewController = NavigationViewController(rootViewController: mainViewController)
            navigationViewController.modalTransitionStyle = .crossDissolve
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
    
    func cleanString(_ char: Character, list : String)->String{
        let lastChar        = list.characters.last!
        var cleanedString   = list
        
        if (lastChar == char){
            cleanedString = (list as NSString).replacingCharacters(in: NSRange(location: list.characters.count - 1, length: 1), with: "")
        }
        return cleanedString
    }
    
    func getAccountFullData(){
        
        var URLList     = UserDefaults.standard.object(forKey: "URL") as! String
        let URLNameList = UserDefaults.standard.object(forKey: "URLName") as! String
        print ("cambios Recientes Swift 3:")
        print(URLList)
        print(URLNameList)
        URLList         = cleanString(",", list: URLList)
        let URLArray    = URLList.components(separatedBy: ",")
        var URLNameArray = URLNameList.components(separatedBy: ",")
        
        if(UserDefaults.standard.object(forKey: "accountCounter") == nil){
            accountCounter  = 0
        }else{
            accountCounter  = UserDefaults.standard.integer(forKey: "accountCounter")
        }
        
        if (accountCounter == URLArray.count){
            
            moveToDocumentsScreen()
            accountCounter = 0
            UserDefaults.standard.set(nil, forKey:"accountCounter")
            UserDefaults.standard.synchronize()
            
        }
        else{
            let URLNameSeparated = URLNameArray[accountCounter]
            print("emilio")
            sessionWarningLabel.text = (NSLocalizedString("LoginViewController.login_URLName", comment: "")) + URLNameSeparated
            sessionWarningLabel.textColor = UIColor(hexString: AppConstants.Color.OPERATION_INFO_BORDER)
            sessionWarningHeightConstraint.constant = 45
            CallWSLogin(self.user, password: self.pass, URLPosition: accountCounter)
        }
        
    }
    
    func CallWSLogin(_ user:String, password:String, URLPosition: Int){
        print ("pasada : ")
        print(accountCounter)
        
        let lstTypeAuthenticate = "USUARIO_PASSWORD"
        var URL                 = ""
        var URLName             = ""
        
        if (UserDefaults.standard.string(forKey: "URL") == nil){
            
            URL = UserDefaults.standard.string(forKey: "URLAccess")!
            URLName = UserDefaults.standard.string(forKey: "URLNameAccess")!
            print("cambios swift 3")
            print(URL, URLName)
            UserDefaults.standard.set(URLName+",", forKey: "URLName")
            UserDefaults.standard.set(URL+",", forKey: "URL")
            UserDefaults.standard.synchronize();
        }
            
        else {
            print ("Entre al if con existencias")
            let fullName        = UserDefaults.standard.object(forKey: "URL") as! String
            var URLStored       = fullName.components(separatedBy: ",")
            let URLEncontrada : String = URLStored[URLPosition]
            URL                 = URLEncontrada
            print (URL)
        }
        
        let parameters  = [""]
        
        
        /*         Example of expected URL "200.66.66.213:8080/"         */
        let path        = URL+"/WS_Rest_HRV/rest/authenticate/login/"+user
        let request     = NSMutableURLRequest(url: Foundation.URL(string:path)!)
        let session    = URLSession.shared
        
        var resultado   = 0
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard data != nil else {
                print("no data found: \(error)")
                DispatchQueue.main.async {
                    self.sessionWarningLabel.text = ""
                }
                self.showAlertMessage("misc.notResponseFromServer")
                return
            }
            
            do {
                print("Entre al do")
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                {
                    if (json["resultado"]as? Int != 0){
                        print("Response: \(json)")
                        let idPerson = json["idPerson"] as? Int
                        
                        UserDefaults.standard.set(idPerson,forKey: "idPerson")
                        UserDefaults.standard.set(lstTypeAuthenticate,forKey: "authType")
                        UserDefaults.standard.set(password,forKey: "identifier")
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
                            self.CallWSUser(URLPosition)
                            
                        }
                        
                    }
                    else{
                       
                        self.showAlertMessage("LoginViewController.notValidUser")
                    }
                } else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                    
                }
            } catch let parseError {
                DispatchQueue.main.async {
                    self.sessionWarningLabel.text = ""
                }
                self.showAlertMessage("misc.notResponseFromServer")
                
            }
            
        })
        task.resume()
        //return resultado
    }
    
    func CallWSUser(_ URLPosition: Int){
        
        print ("call ws user")
        var URL = ""
        var counter = 0
        
        if (UserDefaults.standard.string(forKey: "URL") == nil){
            
            var URL = UserDefaults.standard.object(forKey: "URLAccess") as! String
            var URLName = UserDefaults.standard.object(forKey: "URLNameAccess") as! String
            
            UserDefaults.standard.set(URLName+",", forKey: "URLName")
            UserDefaults.standard.set(URL+",", forKey: "URL")
            UserDefaults.standard.synchronize();
            
        }
        else {
            
            var URLList        = UserDefaults.standard.object(forKey: "URL") as!     String
            var list            = cleanString(",", list: URLList)
            print (list)
            var URLStored       = list.components(separatedBy: ",")
            let URLEncontrada : String = URLStored[URLPosition]
            URL                 = URLEncontrada
            print (URL)
        }
        
        var path       = ""
        let session     = URLSession.shared
        var idDomain    = UserDefaults.standard.object(forKey: "idDomain") as! Int
        print("prueba de impresión idDomain Login")
        print(idDomain)
        
        var idPerson    = UserDefaults.standard.object(forKey: "idPerson") as! Int
        print("prueba de impresión idPersonLogin")
        print(idPerson)
        let authType    = UserDefaults.standard.object(forKey: "authType") as! String
        let pass        = UserDefaults.standard.object(forKey: "identifier") as! String
        
        let JSONObject  =  "{\"idDomain\":\(idDomain),\"idPerson\":\(idPerson),\"autType\":\(authType),\"password\":\(pass)}"
        
        print ("estos son los parametros")
        print(JSONObject)
        path = URL+"/WS_Rest_HRV/rest/authenticate/user"
        
        let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = JSONObject.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    self.sessionWarningLabel.text = ""
                }
                self.showAlertMessage("misc.notResponseFromServer")
                print("no data found: \(error)")
                return
            }
            
            do {
                print ("entre 1er do")
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                {
                    if (json["resultado"]as? Int != 0){
                        
                        print("Response: \(json)")
                        
                        var idRhEmp = json["idRh"]!
                        UserDefaults.standard.set(idRhEmp, forKey: "idRhEmp")
                        
                        UserDefaults.standard.synchronize();
                        
                        if (UserDefaults.standard.object(forKey: "URLIdEmpList") == nil){
                            
                            UserDefaults.standard.set(String(describing:idPerson), forKey:"URLIdEmpList")
                            print("")
                        }
                        else{
                            var URLIdEmpList    = UserDefaults.standard.object(forKey: "URLIdEmpList") as! String
                            print("cambiar")
                            print(URLIdEmpList)
                            var URLIdEmpArray   = URLIdEmpList.components(separatedBy: ",")
                            URLIdEmpArray.append(String(describing:idPerson))
                            var JoinedString    = URLIdEmpArray.joined(separator: ",")
                            UserDefaults.standard.set(JoinedString, forKey:"URLIdEmpList")
                        }
                        
                        if (UserDefaults.standard.string(forKey: "URLIdDomainList") == nil){
                            UserDefaults.standard.set(String(describing:idDomain), forKey:"URLIdDomainList")
                        }
                        else {
                            var URLIdDomainList     = UserDefaults.standard.object(forKey: "URLIdDomainList") as! String
                            var URLIdDomainArray    = URLIdDomainList.components(separatedBy: ",")
                            URLIdDomainArray.append(String(idDomain))
                            var JoinedString        = URLIdDomainArray.joined(separator: ",")
                            UserDefaults.standard.set(JoinedString, forKey: "URLIdDomainList")
                        }
                        if (UserDefaults.standard.object(forKey: "URLIdRhList") == nil){
                            // swift
                            UserDefaults.standard.set(String(describing:idRhEmp), forKey:"URLIdRhList")
                        }
                        else{
                            var URLIdRhList     = UserDefaults.standard.object(forKey: "URLIdRhList") as! String
                            var URLIdRhArray    = URLIdRhList.components(separatedBy: ",")
                            print("insertando")
                            print(idRhEmp as! String)
                            URLIdRhArray.append(idRhEmp as! String)
                            var JoinedString    = URLIdRhArray.joined(separator: ",")
                            UserDefaults.standard.set(JoinedString, forKey: "URLIdRhList")
                        }
                        UserDefaults.standard.synchronize()
                        
                        if (UserDefaults.standard.object(forKey: "accountCounter") == nil){
                            counter = 0
                        }
                        else{
                            counter = UserDefaults.standard.integer(forKey: "accountCounter")
                        }
                        counter += 1
                        UserDefaults.standard.set(counter, forKey:"accountCounter")
                        UserDefaults.standard.synchronize()
                        
                        self.getAccountFullData()
                    }
                    else{
                        self.showAlertMessage("LoginViewController.notValidUser")
                    }
                } else {
                    //swift
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                self.showAlertMessage("LoginViewController.notValidUser")
            }
        })
        task.resume()
    }
    
}

