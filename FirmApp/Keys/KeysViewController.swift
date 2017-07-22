//
//  KeysViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 18/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

enum KeyMode {
    case normal
    case assign
}

class KeysViewController: BaseViewController {

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var addKeyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var operationInfoView: UIView!
    
    @IBOutlet weak var operationBorderView: UIView!
    @IBOutlet weak var operationImageView: UIImageView!
    @IBOutlet weak var operationLabel: UILabel!
    
    @IBOutlet weak var operationInfoHeightConstraint: NSLayoutConstraint!
    
    var keyCellIdentifier = "KeyTableViewCell"
    
    /// The data source
    var dataSource: [Key]! = []

    var mode: KeyMode = KeyMode.normal
    var delegate: KeysProtocol?
    
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorViewHeightContraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initializeTableView()
        
        initializeDataSource()
        
        setUpUI()
        setKeys()
        NotificationCenter.default.addObserver(self, selector: #selector(setKeys), name:NSNotification.Name(rawValue: "refreshKeysTable"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        //Add OperationView
        operationBorderView.layer.borderWidth = 1
        operationBorderView.layer.borderColor = UIColor(hexString: AppConstants.Color.OPERATION_INFO_BORDER).cgColor
        operationLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        operationLabel.font = AppConstants.Font.OPEN_SANS_OPERATION_TITLE
        addKeyButton.setTitle(NSLocalizedString("KeysViewController.add_key", comment: ""), for: UIControlState())
        addKeyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
        addKeyButton.setTitleColor(UIColor(hexString: AppConstants.Color.BUTTON_BLUE), for: UIControlState())
        
        separatorView.backgroundColor = UIColor(hexString: AppConstants.Color.SEPARATOR_GRAY)
        if mode == .assign {
            separatorViewHeightContraint.constant = 5
            separatorViewTopConstraint.constant = 64
            
            // Add Header
            let headerLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            headerLabel.text = NSLocalizedString("KeysViewController.title", comment: "")
            headerLabel.textAlignment = NSTextAlignment.center
            headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
            headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
            self.navigationItem.titleView = headerLabel;
        } else {
            separatorViewHeightContraint.constant = 0
            separatorViewTopConstraint.constant = 0
        }
        
        
    }
    func setKeys(){
        
        print ("setKeys")
        dataSource = []
        
        var keysArray       = [String]()
        var keyFilesArray   = [String]()
        var cerFilesArray   = [String]()
        var position        = 0
        
        if (UserDefaults.standard.object(forKey: "KeyList") != nil){
            print ("keyList not Null")
            var cerFileList = UserDefaults.standard.object(forKey: "CerFileList") as! String
            var keyFileList = UserDefaults.standard.object(forKey: "KeyFileList") as! String
            var keyListNames = UserDefaults.standard.object(forKey: "KeyList") as! String
            
            if (keyListNames.range(of:",") != nil){
                print ("has comma")
                keysArray = keyListNames.components(separatedBy: ",")
                keyFilesArray = keyFileList.components(separatedBy: ",")
                cerFilesArray = cerFileList.components(separatedBy: ",")
            }
            else{
                print ("Not Comma")
                keysArray.append(keyListNames)
                keyFilesArray.append(keyFileList)
                cerFilesArray.append(cerFileList)
            }
            print("---------------------------Arrays--------------------------")
            print(keysArray)
            print(keyFilesArray)
            print(cerFilesArray)
            print("--------------------------Arrays---------------------------")
            
            for keyName in keysArray {
                print ("for keyname on keysarray")
                var cerFile = File(fileName: cerFilesArray[position], filePath: "/")
                var keyFile = File(fileName: keyFilesArray[position], filePath: "/")
                
                print ("..........................................................")
                print (keyFile)
                print (cerFile)
                print ("..........................................................")
                if (position < keysArray.count){
                    position += 1
                }
                
                var keyRow      = Key(name: keyName, files: nil)
                keyRow.files    = [cerFile,keyFile]
                
                dataSource.append(keyRow)
                
                print ("datasource")
                print (dataSource)
                print("passed 2")
                
            }
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
                print("passed 1")
            }
            
            print("passed 3")
        }
        else
        {
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
                print("found empty fields")
            }
        }
        
    }

    @IBAction func addKeyButtonPressed(_ sender: UIButton) {
        print ("Add Key Button Pressed")
        UserDefaults.standard.removeObject(forKey: "temporalCerFile")
        UserDefaults.standard.removeObject(forKey: "temporalKeyFile")
        
        UserDefaults.standard.synchronize()
        let keyViewController = KeyViewController(nibName: "KeyViewController", bundle: nil)
        keyViewController.delegate = self
        self.navigationController?.pushViewController(keyViewController, animated: true)
    }
}

// TableView Helper Methods
extension KeysViewController {
    
    func initializeTableView() {
        tableView.bounces = false
        tableView.style
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: keyCellIdentifier, bundle: nil), forCellReuseIdentifier: keyCellIdentifier)
    }
    
    func initializeDataSource() {
        let file = File(fileName: "Archivo.cer", filePath: "/")
        let file2 = File(fileName: "Archivo.key", filePath: "/")
        var keyContract = Key(name: "LLave_Contratos", files: nil)
        keyContract.files = [file,file2]
        let keySat = Key(name: "LLave_SAT", files: nil)
        let keyCheck = Key(name: "LLave_Cheques", files: nil)
        
        dataSource.append(keyContract)
        dataSource.append(keySat)
        dataSource.append(keyCheck)
        
    }
}

extension KeysViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: KeyTableViewCell = tableView.dequeueReusableCell(withIdentifier: keyCellIdentifier, for: indexPath) as! KeyTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        let key = dataSource[indexPath.row]
        configureCell(cell, key: key,selected: false)
        
        return cell
    }
    
    func configureCell(_ cell: KeyTableViewCell, key: Key, selected: Bool) {
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel.text = key.name
        cell.nameLabel.font = AppConstants.Font.OPEN_SANS_TABLE_HEADER
        if selected {
            cell.headerView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_SELECTED)
            cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT_SELECTED)
            cell.editButton.setImage(UIImage(named: "icon-edit-gray"), for: UIControlState())
            cell.deleteButton.setImage(UIImage(named: "icon-trash-gray"), for: UIControlState())
        } else {
            cell.headerView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT)
            cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT)
            cell.editButton.setImage(UIImage(named: "icon-edit-white"), for: UIControlState())
            cell.deleteButton.setImage(UIImage(named: "icon-trash-white"), for: UIControlState())
        }
        
    }
}

extension KeysViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = dataSource[indexPath.row]
        let cell: KeyTableViewCell = tableView.cellForRow(at: indexPath) as! KeyTableViewCell
        configureCell(cell, key: key, selected: true)
        UIView.animate(withDuration: 0.1, animations: {
            self.configureCell(cell, key: key, selected: false)
        }) 
        if mode == KeyMode.assign {
            
            print ("keyMode para Asignar llave")
            let key = dataSource[indexPath.row]
            print("Llave seleccionada")
            print (indexPath.row)/*
            UserDefaults.standard.set(cerFileList, forKey: "CerFileList")
            UserDefaults.standard.set(keyFileList, forKey: "KeyFileList")
            UserDefaults.standard.set(keyListNames, forKey: "KeyList")*/
            UserDefaults.standard.object(forKey: "KeyList")
            UserDefaults.standard.object(forKey: "CerFileList")
           // UserDefaults.stard
            
            UserDefaults.standard.set(indexPath.row, forKey: "temporalAssignedKey")
            UserDefaults.standard.synchronize()
            delegate?.didSelectKey(key)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53.0
    }
}

extension KeysViewController: DocumentCellProtocol {
    func editDocument(_ indexPath: IndexPath) {
        print ("function editDocument indexpath")
        var currentRow:NSInteger  = indexPath.row
        UserDefaults.standard.set(currentRow, forKey: "position")
        UserDefaults.standard.synchronize()
        let keyViewController = KeyViewController(nibName: "KeyViewController", bundle: nil)
        keyViewController.mode = Mode.edit
        keyViewController.key = dataSource[indexPath.row]
        keyViewController.delegate = self
        self.navigationController?.pushViewController(keyViewController, animated: true)
    }
    
    func deleteDocument(_ indexPath: IndexPath) {
        let keyPasswordViewController = KeyPasswordViewController()
        //        if #available(iOS 8.0, *) {
        keyPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //        } else {
        //            urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        //        }
        var currentRow:NSInteger  = indexPath.row
        UserDefaults.standard.set(currentRow, forKey: "position")
        UserDefaults.standard.synchronize()
        print("delete current key")
        print(currentRow)
        keyPasswordViewController.key = dataSource[indexPath.row]
        keyPasswordViewController.delegate = self
        keyPasswordViewController.mode = Mode.delete
        self.present(keyPasswordViewController, animated: true, completion: nil)
    }
}

extension KeysViewController: ModalProtocolDelegate {
    func modalIsDismissed(_ mode: Mode) {
        if mode == Mode.add {
            operationImageView.image = UIImage(named: "icon-success")
            operationLabel.text = NSLocalizedString("KeysViewController.added_success", comment: "")
            //Show Operation Info
            operationInfoHeightConstraint.constant = 50
            
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(KeysViewController.hideOperationView), userInfo: nil, repeats: false)
        } else if mode == Mode.edit {
            operationImageView.image = UIImage(named: "icon-success")
            operationLabel.text = NSLocalizedString("KeysViewController.modified_success", comment: "")
            //Show Operation Infoedit
            operationInfoHeightConstraint.constant = 50
            
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(KeysViewController.hideOperationView), userInfo: nil, repeats: false)
        } else if mode == Mode.delete {
            operationImageView.image = UIImage(named: "icon-success")
            operationLabel.text = NSLocalizedString("KeysViewController.delete_success", comment: "")
            //Show Operation Info
            operationInfoHeightConstraint.constant = 50
            
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(KeysViewController.hideOperationView), userInfo: nil, repeats: false)
        }
    }
    
    func hideOperationView(){
        UIView.animate(withDuration: 2, animations: {
            self.operationInfoHeightConstraint.constant = 0
        }) 
    }
}
//KeysViewController.swift
 //  FirmApp
 //
 //  Created by mikel.sanchez.local on 18/4/16.
 //  Copyright © 2016 Babel. All rights reserved.
 //
 /*
 import UIKit
 
 enum KeyMode {
 case Normal
 case Assign
 }

 class KeysViewController: BaseViewController {
 
 @IBOutlet weak var separatorView: UIView!
 //@IBOutlet weak var addKeyButton: UIButton!
 @IBOutlet weak var tableView: UITableView!
 @IBOutlet weak var addKeyButton: UIButton!
 
 @IBOutlet weak var operationInfoView: UIView!
 
 @IBOutlet weak var operationBorderView: UIView!
 @IBOutlet weak var operationImageView: UIImageView!
 @IBOutlet weak var operationLabel: UILabel!
 
 @IBOutlet weak var operationInfoHeightConstraint: NSLayoutConstraint!
 
 var keyCellIdentifier = "KeyTableViewCell"
 
 /// The data source
 var dataSource: [Key]! = []
 
 var mode: KeyMode = KeyMode.Normal
 var delegate: KeysProtocol?
 
 @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
 @IBOutlet weak var separatorViewHeightContraint: NSLayoutConstraint!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 initializeTableView()
 initializeDataSource()
 setUpUI()
 setKeys()
 NotificationCenter.default.addObserver(self, selector: #selector(setKeys), name:NSNotification.Name(rawValue: "refreshKeysTable"), object: nil)
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 func setUpUI() {
 
 //Add OperationView
 operationBorderView.layer.borderWidth = 1
 operationBorderView.layer.borderColor = UIColor(hexString: AppConstants.Color.OPERATION_INFO_BORDER).cgColor
 operationLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 operationLabel.font = AppConstants.Font.OPEN_SANS_OPERATION_TITLE
 addKeyButton.setTitle(NSLocalizedString("KeysViewController.add_key", comment: ""), for: .normal)
 addKeyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
 addKeyButton.setTitleColor(UIColor(hexString: AppConstants.Color.BUTTON_BLUE), for: .normal)
 
 separatorView.backgroundColor = UIColor(hexString: AppConstants.Color.SEPARATOR_GRAY)
 if mode == .Assign {
 separatorViewHeightContraint.constant = 5
 separatorViewTopConstraint.constant = 64
 
 // Add Header
    let headerLabel:UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height: 40))
 headerLabel.text = NSLocalizedString("KeysViewController.title", comment: "")
 headerLabel.textAlignment = NSTextAlignment.center
 headerLabel.font = AppConstants.Font.OPEN_SANS_HEADER_TITLE
 headerLabel.textColor = UIColor(hexString: AppConstants.Color.HEADER_TITLE)
 self.navigationItem.titleView = headerLabel;
 } else {
 separatorViewHeightContraint.constant = 0
 separatorViewTopConstraint.constant = 0
 }
 
 
 }
 func setKeys(){
 
 print ("setKeys")
 dataSource = []
 
 
 var keysArray       = [String]()
 var keyFilesArray   = [String]()
 var cerFilesArray   = [String]()
 var position        = 0
 
    if (UserDefaults.standard.object(forKey: "KeyList") != nil){
 print ("keyList not Null")
 var cerFileList = UserDefaults.standard.object(forKey: "CerFileList") as! String
        var keyFileList = UserDefaults.standard.object(forKey: "KeyFileList") as! String
 var keyListNames = UserDefaults.standard.object(forKey: "KeyList") as! String
 
 if (keyListNames.range(of:",") != nil){
 print ("has comma")
 keysArray = keyListNames.components(separatedBy: ",")
 keyFilesArray = keyFileList.components(separatedBy: ",")
 cerFilesArray = cerFileList.components(separatedBy: ",")
 }
 else{
 print ("Not Comma")
 keysArray.append(keyListNames)
 keyFilesArray.append(keyFileList)
 cerFilesArray.append(cerFileList)
 }
 print("---------------------------Arrays--------------------------")
 print(keysArray)
 print(keyFilesArray)
 print(cerFilesArray)
 print("--------------------------Arrays---------------------------")
 
 for keyName in keysArray {
 print ("for keyname on keysarray")
 var cerFile = File(fileName: cerFilesArray[position], filePath: "/")
 var keyFile = File(fileName: keyFilesArray[position], filePath: "/")
 
 print ("..........................................................")
 print (keyFile)
 print (cerFile)
 print ("..........................................................")
 if (position < keysArray.count){
 position += 1
 }
 
 var keyRow      = Key(name: keyName, files: nil)
 keyRow.files    = [cerFile,keyFile]
 
 dataSource.append(keyRow)
 
 print ("datasource")
 print (dataSource)
 print("passed 2")
 
 }
DispatchQueue.main.async {
 self.tableView.dataSource = self
 self.tableView.reloadData()
 print("passed 1")
 }
 
 print("passed 3")
 }
    else
    {
       DispatchQueue.main.async {
            self.tableView.dataSource = self
            self.tableView.reloadData()
            print("found empty fields")
        }
    }
 
 }
 
 
@IBAction func addKeyButtonPressed(_ sender: UIButton) {
    
 //@IBAction func addKeyButtonPressed(sender: UIButton) {
 print ("Add Key Button Pressed")
 UserDefaults.standard.removeObject(forKey: "temporalCerFile")
 UserDefaults.standard.removeObject(forKey: "temporalKeyFile")
 
 UserDefaults.standard.synchronize()
 let keyViewController = KeyViewController(nibName: "KeyViewController", bundle: nil)
 keyViewController.delegate = self
 self.navigationController?.pushViewController(keyViewController, animated: true)
 }
 }
 
 // TableView Helper Methods
 extension KeysViewController {
 
 func initializeTableView() {
 tableView.bounces = false
 tableView.style
 tableView.separatorStyle = .none
 self.tableView.register(UINib(nibName: keyCellIdentifier, bundle: nil), forCellReuseIdentifier: keyCellIdentifier)
 }
 
 func initializeDataSource() {/*
 let file = File(fileName: "Archivo.cer", filePath: "/")
 let file2 = File(fileName: "Archivo.key", filePath: "/")
 var keyContract = Key(name: "LLave_Contratos", files: nil)
 keyContract.files = [file,file2]
 let keySat = Key(name: "LLave_SAT", files: nil)
 let keyCheck = Key(name: "LLave_Cheques", files: nil)
 
 dataSource.append(keyContract)
 dataSource.append(keySat)
 dataSource.append(keyCheck)
 //dataSource=[]
 //setKeys()*/
 }
 }

 extension KeysViewController: UITableViewDataSource {
 func numberOfSectionsInTableView(tableView: UITableView) -> Int {
 return 1
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return dataSource.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 let cell: KeyTableViewCell = tableView.dequeueReusableCell(withIdentifier: keyCellIdentifier, for: indexPath) as! KeyTableViewCell
 
 cell.delegate = self
 cell.indexPath = indexPath
 
 let key = dataSource[indexPath.row]
 configureCell(cell: cell, key: key,selected: false)
 
 return cell
 }
 
 func configureCell(cell: KeyTableViewCell, key: Key, selected: Bool) {
 cell.selectionStyle = UITableViewCellSelectionStyle.none
 cell.nameLabel.text = key.name
 cell.nameLabel.font = AppConstants.Font.OPEN_SANS_TABLE_HEADER
 if selected {
 cell.headerView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_SELECTED)
 cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT_SELECTED)
 cell.editButton.setImage(UIImage(named: "icon-edit-gray"), for: .normal)
 cell.deleteButton.setImage(UIImage(named: "icon-trash-gray"), for: .normal)
 } else {
 cell.headerView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT)
 cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT)
 cell.editButton.setImage(UIImage(named: "icon-edit-white"), for: .normal)
 cell.deleteButton.setImage(UIImage(named: "icon-trash-white"), for: .normal)
 }
 
 }
 }
 
 extension KeysViewController: UITableViewDelegate {
 
 func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
 let key = dataSource[indexPath.row]
 let cell: KeyTableViewCell = tableView.cellForRow(at: indexPath as IndexPath) as! KeyTableViewCell
 configureCell(cell: cell, key: key, selected: true)
 UIView.animate(withDuration: 0.1) {
 self.configureCell(cell: cell, key: key, selected: false)
 }
 if mode == KeyMode.Assign {
 print ("keyMode para Asignar llave")
 let key = dataSource[indexPath.row]
 print("Llave seleccionada")
 print (indexPath.row)
 UserDefaults.standard.set(indexPath.row, forKey: "temporalAssignedKey")
 UserDefaults.standard.synchronize()
 delegate?.didSelectKey(key)
 self.navigationController?.popViewController(animated: true)
 }
 }
 
 func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
 return 53.0
 }
 }
 
 extension KeysViewController: DocumentCellProtocol {
 func editDocument(_ indexPath: IndexPath) {
 print ("function editDocument indexpath")
 var currentRow:NSInteger  = indexPath.row
 UserDefaults.standard.set(currentRow, forKey: "position")
 UserDefaults.standard.synchronize()
 let keyViewController = KeyViewController(nibName: "KeyViewController", bundle: nil)
 keyViewController.mode = Mode.edit
 keyViewController.key = dataSource[indexPath.row]
 keyViewController.delegate = self
 self.navigationController?.pushViewController(keyViewController, animated: true)
 }
 
 func deleteDocument(_ indexPath: IndexPath) {
 print ("function DeleteDocument IndexPath")
 let keyPasswordViewController = KeyPasswordViewController()
 var currentRow:NSInteger  = indexPath.row
 UserDefaults.standard.set(currentRow, forKey: "position")
 UserDefaults.standard.synchronize()
 keyPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
 keyPasswordViewController.key = dataSource[indexPath.row]
 keyPasswordViewController.delegate = self
 keyPasswordViewController.mode = Mode.delete
 self.present(keyPasswordViewController, animated: true, completion: nil)
 }
 }
 
 extension KeysViewController: ModalProtocolDelegate {
 func modalIsDismissed(_ mode: Mode) {
 print ("modo elI")

 if mode == Mode.add {
 print ("function modalIdDissmissed mode Add")
 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshKeysTable"), object: nil)
 /*
 operationImageView.image = UIImage(named: "icon-success")
 operationLabel.text = NSLocalizedString("KeysViewController.added_success", comment: "")
 operationInfoHeightConstraint.constant = 50
 NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(KeysViewController.hideOperationView), userInfo: nil, repeats: false)
 */
 
 } else if mode == Mode.edit {
 print ("function modalIdDissmissed mode Edit")
 operationImageView.image = UIImage(named: "icon-success")
 operationLabel.text = NSLocalizedString("KeysViewController.modified_success", comment: "")
 //Show Operation Infoedit
 operationInfoHeightConstraint.constant = 50
 
 Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(KeysViewController.hideOperationView), userInfo: nil, repeats: false)
 } else if mode == Mode.delete {
 print ("function modalIdDissmissed mode Delete")
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshKeysTable"), object: nil)
 /*
 operationImageView.image = UIImage(named: "icon-success")
 operationLabel.text = NSLocalizedString("KeysViewController.delete_success", comment: "")
 //Show Operation Info
 operationInfoHeightConstraint.constant = 50
 
 NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(KeysViewController.hideOperationView), userInfo: nil, repeats: false)*/
 }
 }
 
    func hideOperationView(){
        UIView.animate(withDuration: 2) {
            self.operationInfoHeightConstraint.constant = 0
        }
    }
 }

*/
