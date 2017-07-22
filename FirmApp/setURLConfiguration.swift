//
//  setURLConfiguration.swift
//  FirmApp
//
//  Created by Elizabeth Hernández Morales on 11/09/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit


class setURLConfiguration: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var textFields: [UITextField]!
    var keyboardHeight:CGFloat!
    
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var URLNameTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var scrollGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var addURLButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textFields = [URLNameTextField, URLTextField]
        
        // Keyboard notifications
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(setURLConfiguration.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(setURLConfiguration.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Get the Tap gesture on ScrollView to hide the keyboard
        scrollGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setURLConfiguration.hideKeyBoard))
        scrollView.addGestureRecognizer(scrollGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardSize.height
        
        print("El teclado se va a mostrar y tiene una altura de: \(keyboardSize.height)")
        setScrollViewPosition()
    }
    
    func hideKeyBoard(){
        // Hide the keyboard
        view.endEditing(true)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 40
        self.view.layoutIfNeeded()
    }
    
    func showAlertMessage(_ alertMessage:String){
        DispatchQueue.main.async(execute: {
            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
        })
        
    }
    
    
    func setScrollViewPosition(){
        // Modificamos el valor de la constante del constraint inferior, le damos la altura del teclado más 20 de marge. De este modo estamos agrandando el Scroll View lo suficiente para poder hacer scroll hacia arriba y trasladar el UITextField hasta que quede a la vista del usuario. Ejecutamos el cambio en el constraint con la función layoutIfNeeded().
        bottomConstraint.constant = keyboardHeight + 20
        self.view.layoutIfNeeded()
        
        // Calculamos la altura de la pantalla
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight: CGFloat = screenSize.height
        
        // Recorremos el array de textFields en busca de quien tiene el foco
        for textField in textFields {
            if textField.isFirstResponder {
                // Guardamos la posición 'Y' del UITextField
                let yPositionField = textField.frame.origin.y
                // Guardamos la altura del UITextField
                let heightField = textField.frame.size.height
                // Calculamos la 'Y' máxima del UITextField
                let yPositionMaxField = yPositionField + heightField
                // Calculamos la 'Y' máxima del View que no queda oculta por el teclado
                let Ymax = screenHeight - keyboardHeight
                // Comprobamos si nuestra 'Y' máxima del UITextField es superior a la Ymax
                if Ymax < yPositionMaxField {
                    // Comprobar si la 'Ymax' el UITextField es más grande que el tamaño de la pantalla
                    if yPositionMaxField > screenHeight {
                        let diff = yPositionMaxField - screenHeight
                        print("UITextField needs space to being showed \(diff) unities")
                        // Hay que añadir la distancia a la que está por debajo el UITextField ya que se sale del screen height
                        //scrollView.setContentOffset(CGPointMake(0, self.keyboardHeight + diff), animated: true)
                    }
                    else{
                        // UITextField is hidden by the keyboard so we need to move the ScrollView
                        scrollView.setContentOffset(CGPoint(x: 0, y: self.keyboardHeight - 20), animated: true)
                        
                    }
                }
                else{
                    print("Not moving the scroll")
                }
            }
        }
    }
    func addFirstURL(_ URLName:String,URL:String){
        
        
        UserDefaults.standard.set(1, forKey: "numero")
        var numero = UserDefaults.standard.integer(forKey: "numero")
        print ("numero obtenido")
        print (numero)

        var numeroString :String = UserDefaults.standard.string(forKey:"numero")!
        print ("numeroString obtenido")
        print (numeroString)
        //.debugDescription
        numeroString.components(separatedBy: ",")
        
        /* TextField Validations */
        if(URLName == "" && URL == ""){
            self.showAlertMessage("misc.missingFields")
        }
        if (URLName == ""){
            self.showAlertMessage("misc.missingURLName")
        }
        if (URL == ""){
            self.showAlertMessage("misc.missingURL")
        }
        
        if (URLName != "" && URL != ""){
            
            
            let url:Foundation.URL = Foundation.URL(string: URLTextField.text!)!
            /* Real URL validation */
            if UIApplication.shared.canOpenURL(url) {
                
                
                
                
                //---------------------------------------------
                
                
                
                /*         Example of expected URL "200.66.66.213:8080/"         */
                let path        = URL+"/WS_Rest_HRV/rest/authenticate/login/pruebas@seguridata.com"
                let request     = NSMutableURLRequest(url: Foundation.URL(string:path)!)
                let session    = URLSession.shared
                
                var resultado   = 0
                let parameters  = [""]
                
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    
                    guard data != nil else {
                        print("no data found: \(error)")
                        self.showAlertMessage("misc.notResponseFromServer")
                        return
                    }
                    
                    do {
                        print("Entre al do")
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        {
                            if (json["resultado"]as? Int != 2){
                                print("Response: \(json)")
                                /* Saving initial value */
                                UserDefaults.standard.set(self.URLTextField.text!,forKey: "URL")
                                /* Saving initial value */
                                UserDefaults.standard.set(self.URLNameTextField.text!,forKey: "URLName")
                                UserDefaults.standard.set("0", forKey: "rememberPassword")
                                let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                                var temporalAssignedKey = "-1"
                                UserDefaults.standard.set(temporalAssignedKey, forKey:"assignedKeysList")
                                UserDefaults.standard.removeObject(forKey:"temporalAssignedKey")
                                UserDefaults.standard.synchronize()
                                
                                /* Auto-Redirecting to Login Screen*/
                                DispatchQueue.main.async {
                                    UIApplication.shared.keyWindow?.rootViewController = loginViewController
                                    self.view.window?.rootViewController!.present(loginViewController, animated: true, completion: nil)
                                }
                                
                                
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
                        self.showAlertMessage("misc.notResponseFromServer")
                    }
                })
                task.resume()
                //------------
            }
            else {
                
                /* Wrong URL, can not connect Alert */
                let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString("misc.insertValidURL", comment: ""), preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
                self.present(alertViewController, animated: true, completion: nil)
                return
            }
        }
    }
    @IBAction func addURLButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let URLName = URLNameTextField.text!
        let URL = URLTextField.text!
        addFirstURL(URLName, URL: URL)
    }
}
