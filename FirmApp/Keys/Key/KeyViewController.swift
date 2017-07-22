//
//  KeyViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 18/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

///Users/ElizabethHernandez/Downloads/FirmApp6/FirmApp/Keys/Key/KeyViewController.swift:12:7: Type 'KeyViewController' does not conform to protocol 'UIDocumentPickerDelegate'
//BaseViewController,
class KeyViewController: BaseViewController, UIDocumentPickerDelegate{
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var certKeysView: UIView!
    @IBOutlet weak var importKeyButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var cerLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    
    var certHeight: CGFloat = 30.0
    var alertMessage = ""
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var documentPickerViewController: UIDocumentPickerViewController!
    
    var mode = Mode.add
    var key: Key?
    
    var delegate: ModalProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
        
        //Initialize keyboard setup
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector( modalIsDismissedAdd), name: NSNotification.Name(rawValue:"modalIsDismissed"), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modalIsDismissedDelete), name: NSNotification.Name(rawValue:"modalIsDismissedDelete"), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector( modalIsDismissedEdit), name: NSNotification.Name(rawValue:"modalIsDismissedEdit"), object:nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAlertMessage(alertMessage:String){
        let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
        return
    }
    
    
    func modalIsDismissedAdd(withNotification notification : NSNotification) {
        delegate?.modalIsDismissed(Mode.add)
        self.navigationController?.popViewController(animated: true)
    }
    func modalIsDismissedDelete(withNotification notification : NSNotification) {
        delegate?.modalIsDismissed(Mode.delete)
        self.navigationController?.popViewController(animated: true)
    }
    func modalIsDismissedEdit(withNotification notification : NSNotification) {
        delegate?.modalIsDismissed(Mode.edit)
        self.navigationController?.popViewController(animated: true)
    }

    @available(iOS 8.0, *)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: Foundation.URL) -> Void{
        print("Document Picker delegate recognized ")
        var fileName = url.lastPathComponent
        var file = url.description
        var file1 = url.pathExtension
        var file2 = url.relativeString
        print(file)
        print(file1)
        print(file2)
        
        print(fileName)
        if (controller.documentPickerMode == UIDocumentPickerMode.import){
            
            var fileExtension = fileName.components(separatedBy: ".")
            if (fileName != ""){
                print(fileExtension)
                do {
                    if ((fileExtension[1] != "cer") && (fileExtension[1] != "key")) {
                        self.alertMessage = "Not a valid selection, choose .cer or .key Files"
                        self.showAlertMessage(alertMessage: self.alertMessage)
                    }
                    else{
                        // Read the file contents
                        do {
                            let hexString = try Data(contentsOf: url)
                            print("File Text: \(hexString)")
                        
                            var strBase64:String = hexString.base64EncodedString(options: .lineLength64Characters)
                            print ("Encoded:" + strBase64)
                            strBase64 = hexString.base64EncodedString(options: .endLineWithLineFeed)
                            print ("Cleaned:" + strBase64)
                        
                            UserDefaults.standard.set(strBase64, forKey: "temporalFile")
                            UserDefaults.standard.synchronize()
                        
                            var hexFile = UserDefaults.standard.object(forKey: "temporalFile") as! String
                            
                            if (fileExtension[1] == "cer")
                            {
                                UserDefaults.standard.set(fileName, forKey: "temporalCerFile")
                                UserDefaults.standard.set(hexFile, forKey: "temporalCer64")
                                UserDefaults.standard.set(fileName, forKey: "temporalNameCer")
                                
                                UserDefaults.standard.synchronize()
                                cerLabel.text = fileName
                            }
                            else{
                                UserDefaults.standard.set(fileName, forKey: "temporalKeyFile")
                                UserDefaults.standard.set(hexFile, forKey: "temporalKey64")
                                
                                UserDefaults.standard.set(nameTextField.text!, forKey: "temporalNameKey")
                                UserDefaults.standard.synchronize()
                                keyLabel.text = fileName
                            }
 
                            UserDefaults.standard.synchronize()
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    
                    }

                }
                catch let error as NSError {
                    print("Failed reading from URL: \(fileExtension), Error: " + error.localizedDescription)
                }
            }
        }
    }
    
    
    @available(iOS 8.0, *)
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    /* Not Used 
    func addFiles(_ key: Key) {
        var yPosition: CGFloat = 0
        
        
        if let files = key.files {
            for (index,file) in files.enumerated() {
                let fileView = Bundle.main.loadNibNamed("FileView", owner: self, options: nil)?[0] as! FileView
                fileView.delegate = self
                fileView.tag = index
                fileView.fileName.text = file.fileName
                
                fileView.frame = CGRect(x: 0, y: yPosition, width: certKeysView.frame.size.width, height: certHeight);
                certKeysView.addSubview(fileView)
                
                certKeysView.frame = CGRect(x: certKeysView.frame.origin.x, y: certKeysView.frame.origin.y, width: certKeysView.frame.width, height: certKeysView.frame.height + certHeight)
                heightConstraint.constant = heightConstraint.constant + certHeight
                yPosition = yPosition + certHeight
            }
        }
    }
    */
    @IBAction func importKeyButtonPressed(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController (documentTypes: ["public.text","public.content", "public.data"], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated:true, completion: nil)
        
    }
    
    @IBAction func addButonPressed(_ sender: UIButton) {
        if (nameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""){
            UserDefaults.standard.set(nameTextField.text!, forKey: "temporalNameKey")
            UserDefaults.standard.synchronize()
            print("sincronizando nombre")
            let keyPasswordViewController = KeyPasswordViewController()
            keyPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            keyPasswordViewController.mode = mode
            self.present(keyPasswordViewController, animated: true, completion: nil)
        }
        else{
            self.showAlertMessage(alertMessage: "KeyPasswordViewController.missingNameField")
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let keyPasswordViewController = KeyPasswordViewController()
        keyPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        keyPasswordViewController.mode = Mode.delete
        keyPasswordViewController.key = self.key
        self.present(keyPasswordViewController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let currentIndex = textFields.index(of: textField), currentIndex < textFields.count-1 {
            textFields[currentIndex+1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension KeyViewController: ModalProtocolDelegate {
    func modalIsDismissed(_ mode: Mode) {
        delegate?.modalIsDismissed(mode)
        self.navigationController?.popViewController(animated: true)
    }
}

extension KeyViewController: CertProtocol {
    func didDeleteCer(_ view: UIView) {
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
    
    func setFiles(position: Int){
        var position        = UserDefaults.standard.object(forKey:"position") as! Int
        var cerFilesList    = ""
        var keyFilesList    = ""
        var keyFiles        = ""
        //var assignedList    = ""
        if (UserDefaults.standard.object(forKey:"KeyFileList") != nil){
            

            var keyFilesListNames   = UserDefaults.standard.object(forKey: "KeyFileList") as! String
            var cerFilesListNames   = UserDefaults.standard.object(forKey: "CerFileList") as! String
        
            var keyFilesArray   = keyFilesListNames.components(separatedBy: ",")
            var cerFilesArray   = cerFilesListNames.components(separatedBy: ",")
            var cerName = cerFilesArray[position]
            var keyName = keyFilesArray[position]
            self.cerLabel.text   = cerName
            self.keyLabel.text   = keyName
        }

    }
        
    func setUpUI() {
        
        textFields = [nameTextField]
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        // Add Header
        let headerLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        if mode == Mode.add {
            headerLabel.text = NSLocalizedString("KeyViewController.title_add", comment: "")
            addButton.setTitle(NSLocalizedString("KeyViewController.add_key", comment: "").uppercased(), for: UIControlState())
        } else {
            headerLabel.text = NSLocalizedString("KeyViewController.title_modify", comment: "")
            addButton.setTitle(NSLocalizedString("KeyViewController.save_key", comment: "").uppercased(), for: UIControlState())
            if let key = key {
                nameTextField.text = key.name
                let positionSelected = UserDefaults.standard.object(forKey: "position")as! Int
                setFiles(position: positionSelected)
                //addFiles(key)
            }
            deleteButton.isHidden = false
        }
        
        headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
        headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
        self.navigationItem.titleView = headerLabel;
        
        nameLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        nameLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        nameLabel.text = NSLocalizedString("KeyViewController.name", comment: "")
        
        nameTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        nameTextField.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        nameTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        
        importKeyButton.setTitle(NSLocalizedString("KeyViewController.import_key", comment: "").uppercased(), for: UIControlState())
        importKeyButton.setTitleColor(UIColor.white, for: UIControlState())
        importKeyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        Utils.setColor(UIColor(hexString:AppConstants.Color.BUTTON_BLUE), forState: UIControlState(), button: importKeyButton)
        
        addButton.setTitleColor(UIColor.white, for: UIControlState())
        addButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        Utils.setColor(UIColor(hexString:AppConstants.Color.BUTTON_GREEN), forState: UIControlState(), button: addButton)
        
        deleteButton.setTitle(NSLocalizedString("ImportKeyViewController.delete", comment: ""), for: UIControlState())
        deleteButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON_SMALL
        deleteButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        
        separatorView.backgroundColor = UIColor(hexString: AppConstants.Color.SEPARATOR_GRAY)
    }
    
}



