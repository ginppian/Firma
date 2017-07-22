// KeyPasswordViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 25/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit
import Foundation

class KeyPasswordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var showPasswordLabel: UILabel!
    @IBOutlet weak var remindPasswordLabel: UILabel!
    @IBOutlet weak var securityLabel: UILabel!
    @IBOutlet weak var remindPassword: CheckButton!
    
 
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    //@IBOutlet weak var addButton: UIButton!
    // @IBOutlet weak var cancelButton: UIButton!
   
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var securityHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var modalBottomMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rememberPassword: NSLayoutConstraint!
    
    @IBOutlet var textFields: [UITextField]!
    
    var delegate: ModalProtocolDelegate?
    var mode: Mode = Mode.add
    var key: Key?
    var alertMessage = ""
    let functionTest = SgLib()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        self.hideKeyboardWhenTappedAround()
        if (UserDefaults.standard.object(forKey: "rememberPassword") != nil){
            if (UserDefaults.standard.object(forKey: "rememberPassword") as! String == "1"){
                var value = UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String
                passwordField.text = value
                remindPasswordLabel.text = NSLocalizedString("KeyPasswordViewController.remind_password", comment: "")
                remindPassword.isChecked = true
            }
            else{
                securityHeightConstraint.constant = 0
                remindPasswordLabel.text = NSLocalizedString("KeyPasswordViewController.remind_password", comment: "")
                remindPassword.isChecked = false
            }
        }
    }
    
    func setUpUI() {
        
        textFields = [passwordField]
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        titleLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        titleLabel.font = AppConstants.Font.OPEN_SANS_POP_UP_TITLE
        
        if mode == Mode.add {
            titleLabel.text = NSLocalizedString("KeyPasswordViewController.title_add", comment: "")
            addButton.setTitle(NSLocalizedString("KeyPasswordViewController.add", comment: "").uppercased(), for: .normal)
        } else if mode == Mode.edit {
            titleLabel.text = NSLocalizedString("KeyPasswordViewController.title_modify", comment: "")
            addButton.setTitle(NSLocalizedString("KeyPasswordViewController.modify", comment: "").uppercased(), for: .normal)
        } else {
            titleLabel.text = NSLocalizedString("KeyPasswordViewController.title_delete1", comment: "") + "\"" + (key?.name)! + "\"" + NSLocalizedString("KeyPasswordViewController.title_delete2", comment: "")
            addButton.setTitle(NSLocalizedString("KeyPasswordViewController.delete", comment: "").uppercased(), for: .normal)
        }
        
        passwordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        passwordLabel.text = NSLocalizedString("KeyPasswordViewController.password", comment: "")
        passwordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        passwordField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        passwordField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        passwordField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        
        showPasswordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        showPasswordLabel.text = NSLocalizedString("KeyPasswordViewController.show_password", comment: "")
        showPasswordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        remindPasswordLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        remindPasswordLabel.text = NSLocalizedString("KeyPasswordViewController.remind_password", comment: "")
        remindPasswordLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        
        securityLabel.textColor = UIColor(hexString: AppConstants.Color.INFO_ERROR_RED)
        securityLabel.text = NSLocalizedString("KeyPasswordViewController.security", comment: "")
        securityLabel.font = AppConstants.Font.OPEN_SANS_WARNING
        
        addButton.setTitleColor(UIColor.white, for: .normal)
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GREEN), forState: .normal, button: addButton)
        addButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        cancelButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: .normal)
        cancelButton.setTitle(NSLocalizedString("KeyPasswordViewController.cancel", comment: "").uppercased(), for: .normal)
        Utils.setColor(UIColor(hexString: AppConstants.Color.BUTTON_GRAY), forState: .normal, button: cancelButton)
        cancelButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        securityHeightConstraint.constant = 0
        
        if UIScreen.main.bounds.height > 667 {
            modalBottomMarginConstraint.constant = 170
        } else if UIScreen.main.bounds.height > 568 {
            modalBottomMarginConstraint.constant = 150
        } else if UIScreen.main.bounds.height > 480 {
            modalBottomMarginConstraint.constant = 60
        } else {
            modalBottomMarginConstraint.constant = 22
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.1) {
            self.transparentBackgroundView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.transparentBackgroundView.backgroundColor = UIColor.clear
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPasswordButtonPressed(sender: CheckButton) {
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
            if (passwordField.text! != ""){
                print (NSLocalizedString("KeyPasswordViewController.remind_password", comment: ""))
                if (UserDefaults.standard.object(forKey: "rememberPassword") as! String != "0"){
                    UserDefaults.standard.set("0", forKey: "rememberPassword")
                }
                else{
                    UserDefaults.standard.set("1", forKey: "rememberPassword")
                }
                sender.checkedImage
            }
            else{
                showAlertMessage(alertMessage: "misc.passwordNotSet")
            }
        } else {
            securityHeightConstraint.constant = 0
        }
        securityLabel.isHidden = sender.isChecked
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if (UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String == passwordField.text!){
            print("password passed")
            print (mode)
            if mode == Mode.add{
                if (UserDefaults.standard.object(forKey: "temporalCerFile") != nil && UserDefaults.standard.object(forKey:"temporalKeyFile") != nil){
                    addKey()
                }
                else {
                    if (UserDefaults.standard.object(forKey: "temporalCerFile") == nil && UserDefaults.standard.object(forKey: "temporalKeyFile") == nil){
                        alertMessage = "KeyPasswordViewController.missingCer&KeyFiles"
                    }
                    else{
                        if (UserDefaults.standard.object(forKey: "temporalCerFile") == nil){alertMessage = "KeyPasswordViewController.missingCerFile"}
                        else{
                            alertMessage = "KeyPasswordViewController.missingKeyFile"
                        }
                    }
                    showAlertMessage(alertMessage: alertMessage)
                }
            }
            else if mode == Mode.edit{
                editKey()
            }
            else {
                removeKey()
            }
        }
        else{
            showAlertMessage(alertMessage: "misc.wrongPassword")
        }
    }
   
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let currentIndex = textFields.index(of: textField), currentIndex < textFields.count-1 {
            textFields[currentIndex+1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func dismissKeyModal(){
        UserDefaults.standard.removeObject(forKey: "temporalCerFile")
        UserDefaults.standard.removeObject(forKey: "temporalKeyFile")
        UserDefaults.standard.removeObject(forKey:"position")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshKeysTable"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDismissedEdit"), object: nil)
        delegate?.modalIsDismissed(mode)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func showAlertMessage(alertMessage:String){

        let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
        return
    }
    
    func addKey(){
        var temporalNameKey = UserDefaults.standard.object(forKey:"temporalNameKey") as! String
        
        var temporalCerFile: String = UserDefaults.standard.object(forKey:"temporalCerFile") as! String
        
        var temporalKeyFile: String = UserDefaults.standard.object(forKey:"temporalKeyFile") as! String
        
        var temporalCerB64   = UserDefaults.standard.object(forKey:"temporalCer64") as! String
        var temporalKeyB64   = UserDefaults.standard.object(forKey:"temporalKey64") as! String

        var pass            = UserDefaults.standard.object(forKey:"userIdentifierFirmApp") as! String

        var response = functionTest.areKeysConsistentSwift(temporalCerB64,privateKey: temporalKeyB64, password: pass)

        print ("response area keys consistant")
        print (response)
        
        if (response == 1 || response == 1000){
            print("addKey Function: 3")
            
            if(UserDefaults.standard.object(forKey:"KeyList") == nil){
                print("if  -  addKey Function:")
                print("addKey Function 4:")
                UserDefaults.standard.set(temporalCerFile, forKey: "CerFileList")
                UserDefaults.standard.set(temporalKeyFile, forKey: "KeyFileList")
                UserDefaults.standard.set(temporalNameKey, forKey: "KeyList")
                UserDefaults.standard.set(temporalCerB64, forKey: "CerB64List")
                UserDefaults.standard.set(temporalKeyB64, forKey: "KeyB64List")
                
                UserDefaults.standard.synchronize()
            }
            else{
                print("else  -  addKey Function:")
                print("addKey Function 5:")
                var cerFileList = UserDefaults.standard.object(forKey:"CerFileList") as! String
                var keyFileList = UserDefaults.standard.object(forKey:"KeyFileList") as! String
                var keyListNames = UserDefaults.standard.object(forKey:"KeyList") as! String
                var keyb64List = UserDefaults.standard.object(forKey:"KeyB64List") as! String
                var cerb64List = UserDefaults.standard.object(forKey:"CerB64List") as! String
                
                cerFileList += "," + temporalCerFile
                keyFileList += "," + temporalKeyFile
                keyListNames += "," + temporalNameKey
                keyb64List += "," + temporalKeyB64
                cerb64List += "," + temporalCerB64
                
                UserDefaults.standard.set(cerFileList, forKey: "CerFileList")
                UserDefaults.standard.set(keyFileList, forKey: "KeyFileList")
                UserDefaults.standard.set(keyListNames, forKey: "KeyList")
                UserDefaults.standard.set(keyb64List, forKey: "KeyB64List")
                UserDefaults.standard.set(cerb64List, forKey: "CerB64List")

                UserDefaults.standard.synchronize()
                print("****************PPPPP****************")
                print(cerFileList)
                print(keyFileList)
                print(keyListNames)
                
                print("***************PPPPPP*****************")
            }
            UserDefaults.standard.set(nil, forKey:"temporalNameKey")
            UserDefaults.standard.set(nil, forKey:"temporalCerKey")
            UserDefaults.standard.set(nil, forKey: "temporalCer64")
            UserDefaults.standard.set(nil, forKey: "temporalKey64")
            UserDefaults.standard.removeObject(forKey:"temporalCerFile")
            UserDefaults.standard.removeObject(forKey:"temporalKeyFile")
           
            UserDefaults.standard.synchronize()
    
            delegate?.modalIsDismissed(mode)
            self.dismiss(animated: false, completion: nil)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"refreshKeysTable"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDismissed"), object: nil)

        }
        else {
            alertMessage = "KeyPasswordViewController.wrongKeys"
            showAlertMessage(alertMessage: alertMessage)
        }
    }
    
    func removeKey(){
        var position        = UserDefaults.standard.object(forKey:"position") as! Int
        var cerFilesList    = ""
        var keyFilesList    = ""
        var keyFiles        = ""
        var assignedList    = ""
        var counter         = 0
        if (UserDefaults.standard.object(forKey:"KeyFileList") != nil){
            
            var keyListNames        = UserDefaults.standard.object(forKey: "KeyList") as! String
            var keyFilesListNames   = UserDefaults.standard.object(forKey: "KeyFileList") as! String
            var cerFilesListNames   = UserDefaults.standard.object(forKey: "CerFileList") as! String
            var keyb64List          = UserDefaults.standard.object(forKey: "KeyB64List") as! String
            var cerb64List          = UserDefaults.standard.object(forKey: "CerB64List") as! String
            var assignedKeysList    = UserDefaults.standard.object(forKey:"assignedKeysList") as! String
            
            var keysArray       = keyListNames.components(separatedBy: ",")
            var keyFilesArray   = keyFilesListNames.components(separatedBy: ",")
            var cerFilesArray   = cerFilesListNames.components(separatedBy: ",")
            var cerb64Array     = cerb64List.components(separatedBy:",")
            var keyb64Array     = keyb64List.components(separatedBy:",")
            var assignedKeysArray = assignedKeysList.components(separatedBy:",")
            
            keysArray.remove(at: position)
            keyFilesArray.remove(at: position)
            cerFilesArray.remove(at: position)
            cerb64Array.remove(at: position)
            keyb64Array.remove(at: position)
            //assignedKeysArray.removeAtIndex(position)
            print ("position")
            print (String(position))
            for keys in assignedKeysArray{
                if(keys == String(position)){
                 assignedKeysArray[counter] = "-1"
            }
               /* var keyToFind = String(position)
                let index = assignedKeysArray.index(of: keyToFind)
                print ("index de la posición en donde está ligado")
                print(index)
                if ((index) != nil){
                    print("si existe en la cadena")
                    assignedKeysArray[index!] = "-1"*/

            }
            
            if (keysArray.count != 0){
                keyFiles        = keysArray.joined(separator: ",")
                cerFilesList    = keyFilesArray.joined(separator: ",")
                keyFilesList    = cerFilesArray.joined(separator: ",")
                keyb64List      = keyb64Array.joined(separator: ",")
                cerb64List      = cerb64Array.joined(separator: ",")
                assignedList    = assignedKeysArray.joined(separator: ",")
                
                UserDefaults.standard.set(cerFilesList, forKey: "CerFileList")
                UserDefaults.standard.set(keyFilesList, forKey: "KeyFileList")
                UserDefaults.standard.set(keyFiles, forKey: "KeyList")
                UserDefaults.standard.set(keyb64List , forKey: "KeyB64List")
                UserDefaults.standard.set(cerb64List, forKey: "CerB64List")
                
                UserDefaults.standard.set(assignedList, forKey: "assignedKeysList")
                UserDefaults.standard.synchronize()
                
            }
            else {
                UserDefaults.standard.removeObject(forKey: "CerFileList")
                UserDefaults.standard.removeObject(forKey: "KeyFileList")
                UserDefaults.standard.removeObject(forKey: "KeyList")
                UserDefaults.standard.removeObject(forKey: "KeyB64List")
                UserDefaults.standard.removeObject(forKey: "CerB64List")
                UserDefaults.standard.set("-1", forKey: "assignedKeysList")
                UserDefaults.standard.synchronize()
            }
            
        }
        UserDefaults.standard.removeObject(forKey:"position")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshKeysTable"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDismissedDelete"), object: nil)
        delegate?.modalIsDismissed(mode)
        self.dismiss(animated: false, completion: nil)
    }
    
    func editKey(){
        
        var flagCer     = 0
        var flagKey     = 0
        var flagName    = 1
        
        var temporalCerFile = ""
        var temporalKeyFile = ""
        var temporalKeyB64  = ""
        var temporalCerB64  = ""
        
        var position        = UserDefaults.standard.object(forKey: "position") as! Int
        var temporalNameKey = UserDefaults.standard.object(forKey:"temporalNameKey") as! String
        var pass = UserDefaults.standard.object(forKey:"userIdentifierFirmApp") as! String

        if(UserDefaults.standard.object(forKey: "temporalCerFile") != nil){
            print(UserDefaults.standard.object(forKey: "temporalCerFile")as! String)
            temporalCerFile = UserDefaults.standard.object(forKey: "temporalCerFile") as! String
            temporalCerB64   = UserDefaults.standard.object(forKey:"temporalCer64") as! String
            flagCer=1}
      
        if(UserDefaults.standard.object(forKey:"temporalKeyFile") != nil){
            print("Aqui estaba el error")
            print(UserDefaults.standard.object(forKey:"temporalKeyFile"))
            temporalKeyFile  = UserDefaults.standard.object(forKey:"temporalKeyFile") as! String
            temporalKeyB64   = UserDefaults.standard.object(forKey:"temporalKey64") as! String
            flagKey=1}
        

        var keyListNames            = UserDefaults.standard.object(forKey:"KeyList") as! String
        var keyFilesListNames       = UserDefaults.standard.object(forKey:"KeyFileList") as! String
        var cerFilesListNames       = UserDefaults.standard.object(forKey:"CerFileList") as! String
        var keyb64List              = UserDefaults.standard.object(forKey: "KeyB64List") as! String
        var cerb64List              = UserDefaults.standard.object(forKey: "CerB64List") as! String
        
        if  (keyListNames.contains(",")){
            
            var keysArray       = keyListNames.components(separatedBy:",")
            var keyFilesArray   = keyFilesListNames.components(separatedBy:",")
            var cerFilesArray   = cerFilesListNames.components(separatedBy:",")
            var cerb64Array     = cerb64List.components(separatedBy:",")
            var keyb64Array     = keyb64List.components(separatedBy:",")
            
            
            if(flagName==1){
                print("nombre")
                keysArray[position] = temporalNameKey
            }
            
            if(flagKey==1){
                print("key")
                keyFilesArray[position] = temporalKeyFile
                keyb64Array[position] = temporalKeyB64
            }
            else{
                temporalKeyB64  = keyb64Array[position]
                temporalKeyFile = keyFilesArray[position]
            }
            if(flagCer==1){
                print("cer")
                cerFilesArray[position] = temporalCerFile
                cerb64Array[position] = temporalCerB64
            }
            else{
                temporalCerFile = cerFilesArray[position]
                temporalCerB64  = cerb64Array[position]
            }

            var response = functionTest.areKeysConsistentSwift(temporalCerB64,privateKey: temporalKeyB64, password: pass)
            
            if (response == 1 || response == 1000){

                var keyFiles        = keysArray.joined(separator:",")
                var cerFilesList    = keyFilesArray.joined(separator:",")
                var keyFilesList    = cerFilesArray.joined(separator:",")
                var keyb64List      = keyb64Array.joined(separator: ",")
                var cerb64List      = cerb64Array.joined(separator: ",")
            
                UserDefaults.standard.set(cerFilesList, forKey: "CerFileList")
                UserDefaults.standard.set(keyFilesList, forKey: "KeyFileList")
                UserDefaults.standard.set(keyb64List, forKey:"KeyB64List")
                UserDefaults.standard.set(cerb64List, forKey:"CerB64List")
                UserDefaults.standard.set(keyFiles, forKey: "KeyList")
                UserDefaults.standard.synchronize()
                dismissKeyModal()
            
            }
            else{
                alertMessage = "KeyPasswordViewController.wrongKeys"
                showAlertMessage(alertMessage: alertMessage)
            }
        }
            
        else{

            print("entre a else")
            var pass = UserDefaults.standard.object(forKey:"userIdentifierFirmApp") as! String

            if(UserDefaults.standard.object(forKey:"temporalKeyFile") != nil && UserDefaults.standard.object(forKey:"temporalCerFile") == nil){
                temporalKeyFile = UserDefaults.standard.object(forKey:"temporalKeyFile") as! String

                temporalCerB64 = UserDefaults.standard.object(forKey:"CerB64List") as! String
                temporalKeyB64 = UserDefaults.standard.object(forKey:"temporalKey64") as! String
                var response = functionTest.areKeysConsistentSwift(temporalCerB64,privateKey: temporalKeyB64, password: pass)
                
                if (response == 1 || response == 1000){
                    UserDefaults.standard.set(temporalKeyFile, forKey: "KeyFileList")
                    UserDefaults.standard.set(temporalKeyB64, forKey: "KeyB64List")
                    UserDefaults.standard.synchronize()
                    dismissKeyModal()
                }
                else{
                    alertMessage = "KeyPasswordViewController.wrongKeys"
                    showAlertMessage(alertMessage: alertMessage)
                }
            }
            
            if(UserDefaults.standard.object(forKey:"temporalCerFile") != nil && UserDefaults.standard.object(forKey:"temporalKeyFile") == nil){
                temporalCerFile = UserDefaults.standard.object(forKey:"temporalCerFile") as! String
                temporalCerB64 = UserDefaults.standard.object(forKey:"temporalCer64") as! String
                temporalKeyB64 = UserDefaults.standard.object(forKey:"KeyB64List") as! String
                
                var response = functionTest.areKeysConsistentSwift(temporalCerB64,privateKey: temporalKeyB64, password: pass)
                
                if (response == 1 || response == 1000){
                    UserDefaults.standard.set(temporalCerFile, forKey: "CerFileList")
                    UserDefaults.standard.set(temporalCerB64, forKey: "CerB64List")
                    UserDefaults.standard.synchronize()
                    dismissKeyModal()
                }
                else{
                    alertMessage = "KeyPasswordViewController.wrongKeys"
                    showAlertMessage(alertMessage: alertMessage)
                }
            }
            if (UserDefaults.standard.object(forKey:"temporalCerFile") != nil && (UserDefaults.standard.object(forKey:"temporalKeyFile") != nil)){
                temporalCerFile = UserDefaults.standard.object(forKey:"temporalCerFile") as! String
                temporalCerB64 = UserDefaults.standard.object(forKey:"temporalCer64") as! String
                temporalKeyFile = UserDefaults.standard.object(forKey:"temporalKeyFile") as! String
                temporalKeyB64 = UserDefaults.standard.object(forKey:"temporalKey64") as! String
                var response = functionTest.areKeysConsistentSwift(temporalCerB64,privateKey: temporalKeyB64, password: pass)
                
                if (response == 1 || response == 1000){
                    UserDefaults.standard.set(temporalCerFile, forKey: "CerFileList")
                    UserDefaults.standard.set(temporalCerB64, forKey: "CerB64List")
                    UserDefaults.standard.set(temporalKeyFile, forKey: "KeyFileList")
                    UserDefaults.standard.set(temporalKeyB64, forKey: "KeyB64List")
                    dismissKeyModal()
                }
                else{
                    alertMessage = "KeyPasswordViewController.wrongKeys"
                    showAlertMessage(alertMessage: alertMessage)
                }
            }
            UserDefaults.standard.set(temporalNameKey, forKey: "KeyList")
            UserDefaults.standard.synchronize()
            
            if (UserDefaults.standard.object(forKey:"temporalCerFile") == nil && UserDefaults.standard.object(forKey:"temporalKeyFile") == nil){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshKeysTable"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDismissedEdit"), object: nil)
                delegate?.modalIsDismissed(mode)
                self.dismiss(animated: false, completion: nil)
            }
        
    /*}
        else{
            if (UserDefaults.standard.object(forKey:"temporalKeyFile") == nil && UserDefaults.standard.object(forKey:"temporalCerFile") == nil){
         
                    var temporalNameKey   = UserDefaults.standard.object(forKey:"temporalNameKey") as! String
                    var keyListNames    = UserDefaults.standard.object(forKey:"KeyList") as! String
                    var keysArray       = keyListNames.components(separatedBy:",")
                    keysArray[position] = temporalNameKey
                    print (keysArray[position])
                    var keyFiles        = keysArray.joined(separator:",")
                    UserDefaults.standard.set(keyFiles, forKey: "KeyList")
                    UserDefaults.standard.synchronize()
             /*
                  showAlertMessage(alertMessage: "KeyPasswordViewController.missingCer&KeyFiles")}
            if(UserDefaults.standard.object(forKey:"temporalKeyFile") == nil){
                   showAlertMessage(alertMessage: "KeyPasswordViewController.missingKeyFile")}
            if(UserDefaults.standard.object(forKey:"temporalCerFile") == nil){
            showAlertMessage(alertMessage: "KeyPasswordViewController.missingCerFile")*/
            }
           /* else{
                if (UserDefaults.standard.object(forKey:"temporalKeyFile") != nil && UserDefaults.standard.object(forKey:"temporalCerFile") == nil){
                    showAlertMessage(alertMessage: "KeyPasswordViewController.missingCerFile")}
                if (UserDefaults.standard.object(forKey:"temporalCerFile") != nil && UserDefaults.standard.object(forKey:"temporalKeyFile") == nil){
                    showAlertMessage(alertMessage: "KeyPasswordViewController.missingKeyFile")}
            }*/
            
        }*/
       
        }
    
    }
    
    
}

