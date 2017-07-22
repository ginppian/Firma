//
//  SignedViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 19/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class SignedViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var fromCalendarImage: UIImageView!
    
    @IBOutlet weak var toTextField:     UITextField!
    @IBOutlet weak var toCalendarImage: UIImageView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var datePickerView: DatePicker!
    var opened: Bool = false
    var currentTextField: UITextField?
    let cellIdentifier = "HistoryDocTableViewCell"
    
    /// The data source
    var dataSource: [Document]! = []
    
    //Global Documents Array, Dictionary and B64 Document initialization
    
    var array = Array<AnyObject>()
    var dict = Dictionary<String, AnyObject>()
    var base64Document  = ""
    var iniDateString   = ""
    var endDateString   = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        initializeDataSource()
        setUpUI()
        
        NotificationCenter.default.addObserver(self,selector: #selector(initializeTableView),name: NSNotification.Name(rawValue: "CallWSReceiptGet") ,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(initializeDataSource),name: NSNotification.Name(rawValue: "CallWSReceiptGet") ,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(SearchDocuments),name: NSNotification.Name(rawValue: "CallWSGetHistorySigned") ,object: nil)
        
        manageIterations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpUI() {
        searchButton.setTitle(NSLocalizedString("SignedViewController.search", comment: "").uppercased(), for: UIControlState())
        searchButton.setTitleColor(UIColor.white, for: UIControlState())
        Utils.setColor(UIColor(hexString:AppConstants.Color.BUTTON_GREEN), forState: UIControlState(), button: searchButton)
        searchButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        fromTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        fromTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        fromTextField.placeholder = NSLocalizedString("SignedViewController.from", comment: "")
        fromTextField.textColor = UIColor(hexString:AppConstants.Color.TEXT_PRIMARY)
        fromTextField.inputView = UIView()
        
        fromCalendarImage.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        toTextField.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        toTextField.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        toTextField.placeholder = NSLocalizedString("SignedViewController.to", comment: "")
        toTextField.textColor = UIColor(hexString:AppConstants.Color.TEXT_PRIMARY)
        toTextField.inputView = UIView()
        toCalendarImage.backgroundColor = UIColor(hexString: AppConstants.Color.TEXT_FIELD_GRAY)
        
        dateLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        dateLabel.font = AppConstants.Font.OPEN_SANS_FORM_TEXT
        dateLabel.text = NSLocalizedString("SignedViewController.range", comment: "")
        
    }
    
    func setUpDatePicker() {
        datePickerView = Bundle.main.loadNibNamed("DatePicker", owner: self, options: nil)?[0] as! DatePicker
        datePickerView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.size.width, height: datePickerView.frame.height)
        datePickerView.delegate = self
        
        datePickerView.doneBarButton.title = NSLocalizedString("DatePicker.done", comment: "")
        datePickerView.removeBarButton.title = NSLocalizedString("DatePicker.remove", comment: "")
        
        view.addSubview(datePickerView)
    }
    
    @IBAction func datePickerBeginAction(_ sender: UITextField) {
        currentTextField = sender
        datePickerView.tag = sender.tag
        if !opened {
            presentPicker(datePickerView)
        }
    }
    
    func presentPicker (_ menuView: UIView) {
        opened = true
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            menuView.frame = CGRect(x: menuView.frame.origin.x, y: menuView.frame.origin.y - menuView.frame.size.height, width: menuView.frame.width, height: menuView.frame.size.height)
        })
        
    }
    
    func dismissPicker() {
        if opened {
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.datePickerView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.height, width: self.view.frame.width, height: self.datePickerView.frame.height)
            })
        }
        opened = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissPicker()
    }
    @IBAction func SearchDocuments(_ sender: Any) {
        print ("Realizando búsqueda de documentos por rango de fecha")
        self.array = []
        UserDefaults.standard.removeObject(forKey: "HistoryURLPosition")
        
        print ("iniDateString")
        print (iniDateString)
        print ("endDateString")
        print (endDateString)
        if (fromTextField.text != "" && toTextField.text != ""){
            if ((iniDateString.compare(endDateString) == ComparisonResult.orderedDescending)){
                //|| (iniDateString.compare(endDateString) == NSComparisonResult.OrderedSame)
                showAlertMessage("SignedViewController.FirstDateAlert")
            }
            else{
                manageIterations()
                UserDefaults.standard.removeObject(forKey: "signedMultilateralIds")
                UserDefaults.standard.synchronize()
            }
        }
        else{
            if(fromTextField.text == "" && toTextField.text == ""){
                manageIterations()
                UserDefaults.standard.removeObject(forKey: "signedMultilateralIds")
                UserDefaults.standard.synchronize()
            }
            else{
                if (fromTextField.text == "") {
                    showAlertMessage("SignedViewController.MissingFirstDate")
                }
                if (toTextField.text == "") {
                    showAlertMessage("SignedViewController.MissingSecondDate")
                }
            }
            
        }
        
        
    }
}

// TableView Helper Methods
extension SignedViewController {
    func showAlertMessage(_ alertMessage:String){
        DispatchQueue.main.async(execute: {
            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
        })
        
    }
    
    func initializeTableView() {
        tableView.bounces = false
        tableView.style
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func initializeDataSource() {
        print ("llame a inicializar la tabla")
        dataSource = []
        
        for documentInfo in self.array {
            print ("llame a inicializar la tabla 1")
            var fileName        = documentInfo["fileName"] as! String
            var endDate         = documentInfo["endDate"] as! String
            var iniDate         = documentInfo["iniDate"] as! String
            var multilateralId  = documentInfo["multilateralId"] as! Int
            var URLName         = documentInfo["URLName"] as! String
            
            var document = Document(name: fileName, dateIni: iniDate, dateEnd: endDate , url: URLName, location: "XXXXX", obs: "None", multilateralId: multilateralId, state: State.collapsed)
            dataSource.append(document)
            
            print ("llame a inicializar la tabla 2")
            /*   No borrar, me muestra algo importante
             var document = Document(name: "Documento "+index.description, dateIni: "24/03/1987", dateEnd: "24/03/1987", size: 13.0, url: "Nominas", location: "XXXXX", obs: "El documento se declina ya que los datos escritos dentro del mismo no correspondena los que se describenn el contrato inicial, favor de corregir.", state: State.Collapsed)
             dataSource.append(document)*/
            
        }
        DispatchQueue.main.async{
            self.tableView.dataSource = self
            self.tableView.reloadData()
            print ("llame a inicializar la tabla 3")
        }
    }
    
    func configureCell(_ cell: HistoryDocTableViewCell, document: Document) {
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dateIni = NSLocalizedString("SignedViewController.date_ini", comment: "")
        let dateEnd = NSLocalizedString("SignedViewController.date_end", comment: "")
        let url = NSLocalizedString("SignedViewController.url", comment: "")
        let size = NSLocalizedString("SignedViewController.size", comment: "")
        
        cell.nameLabel.text = document.name
        cell.dateIniLabel.text = dateIni + ":" + document.dateIni
        cell.dateEndLabel.text = dateEnd + ":" + document.dateEnd
        cell.urlName.text = url + ":" + document.url
        //cell.sizeLabel.text = size + ":" + document.size.description + "Kb"
        
        cell.nameLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE_BOLD
        cell.dateIniLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.dateEndLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.urlName.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.sizeLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.showLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        
        
        if document.state == State.collapsed {
            cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.dateIniLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.dateEndLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.urlName.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.sizeLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.showLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.showButton.setImage(UIImage(named: "icon-show"), for: UIControlState())
            cell.calendarImage.image = UIImage(named: "icon-calendar")
            
            cell.contentView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_DOC)
        } else {
            cell.nameLabel.textColor = UIColor.white
            cell.dateIniLabel.textColor = UIColor.white
            cell.dateEndLabel.textColor = UIColor.white
            cell.urlName.textColor = UIColor.white
            cell.sizeLabel.textColor = UIColor.white
            cell.showLabel.textColor = UIColor.white
            cell.showButton.setImage(UIImage(named: "icon-show-white"), for: UIControlState())
            cell.calendarImage.image = UIImage(named: "icon-calendar-white")
            
            cell.contentView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_DOC_SELECTED)
        }
    }
    
    /**
     Deselects all the rows except the indexpath passed
     
     - parameter index: index not deselected
     */
    func deselectRows(_ index: Int) {
        for (i,document) in dataSource.enumerated() {
            if i != index {
                var documentReplace = document
                documentReplace.state = State.collapsed
                dataSource[i] = documentReplace
            }
        }
    }
    
}

extension SignedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: HistoryDocTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryDocTableViewCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        configureCell(cell, document: dataSource[indexPath.row])
        
        return cell
    }
}
extension SignedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var document = dataSource[indexPath.row]
        if document.state == State.collapsed {
            document.state = State.expanded
        } else {
            document.state = State.collapsed
        }
        dataSource[indexPath.row] = document
        
        deselectRows(indexPath.row)
        //configureCell(cell!, document: dataSource[indexPath.row])
        
        tableView.reloadData()
        
        //            tableView.beginUpdates()
        //            updateCells(parent, index: indexPath.row)
        //            tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0 + 3.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let additionalSeparatorThickness = CGFloat(3)
        let additionalSeparator = UIView(frame: CGRect(x: 0,
                                                       y: cell.frame.size.height - additionalSeparatorThickness,
                                                       width: cell.frame.size.width,
                                                       height: additionalSeparatorThickness))
        additionalSeparator.backgroundColor = UIColor.white
        cell.addSubview(additionalSeparator)
    }
}

extension SignedViewController: HistoryCellProtocol {
    func viewDocument(_ indexPath: IndexPath) {
        let viewerViewController = ViewerViewController(nibName: "ViewerViewController", bundle: nil)
        viewerViewController.document = dataSource[indexPath.row]
        
        self.navigationController?.pushViewController(viewerViewController, animated: true)
    }
}

extension SignedViewController : DatePickerDelegate {
    
    func removePressed() {
        if datePickerView.tag == 0 {
            //fromTextField.text = nil
        } else {
           // toTextField.text = nil
        }
    }
    
    func donePressed() {
        dismissPicker()
    }
    
    func datePickerValueChanged(_ date: Date) {
        print("DataPicker en uso")
        let dateFormatter = DateFormatter()
        let dateFormatterString = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatterString.dateFormat = "MMM d, yyyy"
        dateFormatterString.shortMonthSymbols = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul","Aug","Sep","Oct", "Nov","Dec"]
        
        if datePickerView.tag == 0 {
            print("Fecha inicial seleccionada por usuario: ")
            fromTextField.text = dateFormatter.string(from: date)
            print (fromTextField.text!)
            let iniDatePicker = dateFormatterString.string(from: date)
            print(iniDatePicker)
            
            iniDateString = iniDatePicker + " 0:00:00 AM"
            
        } else {
            print("Fecha final seleccionada por usuario: ")
            toTextField.text = dateFormatter.string(from: date)
            print (toTextField.text!)
            let endDatePicker = dateFormatterString.string(from: date)
            print(endDatePicker)
            endDateString = endDatePicker + " 11:59:00 PM"
        }
    }
    
    func getURLListSize()->Int{
        let URLList         = UserDefaults.standard.object(forKey: "URL") as! String
        let URLArray        = URLList.components(separatedBy: ",")
        return URLArray.count
    }
    
    func getURLInformationFromPosition (_ position:Int)->(String,String,String,String,String){
        let URLList         = UserDefaults.standard.object(forKey: "URL") as! String
        let URLNamesList    = UserDefaults.standard.object(forKey: "URLName") as! String
        let idsDomainList   = UserDefaults.standard.object(forKey: "URLIdDomainList") as! String
        let idsEmpList      = UserDefaults.standard.object(forKey: "URLIdEmpList") as! String
        let idsRhList       = UserDefaults.standard.object(forKey: "URLIdRhList") as! String
        
        var URLArray        = URLList.components(separatedBy: ",")
        var URLNamesArray   = URLNamesList.components(separatedBy: ",")
        var idsDomainArray  = idsDomainList.components(separatedBy: ",")
        var idsEmpArray     = idsEmpList.components(separatedBy: ",")
        var idsRhArray      = idsRhList.components(separatedBy: ",")
        
        return (URLArray[position], URLNamesArray[position], idsDomainArray[position], idsEmpArray[position], idsRhArray[position])
    }
    
    func manageIterations(){
        let size    = getURLListSize()
        var counter:Int = 0
        
        if(UserDefaults.standard.object(forKey: "HistoryURLPosition") != nil){
            counter = UserDefaults.standard.integer(forKey: "HistoryURLPosition")
        }
            
        else{
            UserDefaults.standard.set(counter, forKey: "HistoryURLPosition")
            UserDefaults.standard.synchronize()
        }
        
        if (counter == size){
            UserDefaults.standard.removeObject(forKey: "HistoryURLPosition")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSReceiptGet"), object: nil)
        }
        else{
            if(UserDefaults.standard.object(forKey: "HistoryURLPosition") != nil){
                counter = UserDefaults.standard.integer(forKey: "HistoryURLPosition")
                let response = getURLInformationFromPosition(counter)
                CallWSGetHistory(counter, URL: response.0, URLName: response.1, idDomain: response.2, idEmp: response.3, idRhEmp: response.4)
            }
        }
    }

    func CallWSGetHistory(_ position: Int, URL:String, URLName:String, idDomain:String, idEmp:String ,idRhEmp:String){
        print ("callwsGetHistory")
        let dateFormatterDeny = DateFormatter()
        var path       = URL+"/WS_Rest_HRV/rest/receipt/get"
        let session     = URLSession.shared
        var multilateralIdList = ""
        
        print ("idRH")
        print (idRhEmp)
        print ("idDomain")
        print (idDomain)
        var emptyParameter  = ""
        print ("emptyParameter")
        print (emptyParameter)
        var statusReceipt   = "CONCLUIDO"
        print ("statusReceipt")
        print (statusReceipt)
        var iniDate         = "Aug 3, 1999 3:47:15 PM"
        print ("iniDate")
        print (iniDate)
        var endDate         = "Dec 3, 2025 3:47:15 PM"
        print ("endDate")
        print (endDate)
        var result          = 1
        
        if (iniDateString != ""){
            iniDate = iniDateString
        }
        if (endDateString != ""){
            endDate = endDateString
        }
        let JSONObject  =  "{\"idDomain\":\(idDomain),\"idRhEmp\":\(idRhEmp),\"statusReceipt\":\"\(statusReceipt)\",\"iniDate\":\"\(iniDate)\",\"endDate\":\"\(endDate)\",\"userDomain\":\"\",\"passwordDomain\":\"\",\"resultado\":\(1)}"
        print ("estos son los parametros")
        print(JSONObject)
        
        let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = JSONObject.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                    if (json["resultado"]as? Int != 0){
                        print("Response: \(json)")
                        print ("Response lstReceipts :\(json["lstReceipts"])")
                        var document = ""
                        if var documentsArray = json["lstReceipts"] as? [[String: AnyObject]] {
                            for document in documentsArray{
                                var docType     = document["docType"]
                                var iniDate     = document["iniDate"]
                                var endDate     = document["endDate"]
                                var fileName    = document["fileName"]
                                var signDate    = document["signDate"]
                                var multilateralId = document["multilateralId"]
                                UserDefaults.standard.set(multilateralId, forKey: "tempMultilateralId")
                                UserDefaults.standard.synchronize()
                                //swift
                                dateFormatterDeny.locale = Locale(identifier: "en_US")
                                dateFormatterDeny.dateFormat = "MMM d, yyyy HH:mm:ss a"
                                
                                var dateGet = dateFormatterDeny.date(from: iniDate as! String)
                                var dateGetEnd = dateFormatterDeny.date(from: endDate as! String)
                                
                                dateFormatterDeny.dateFormat = "dd/MM/YYYY"
                                //swift
                                iniDate = dateFormatterDeny.string(from: dateGet!) as AnyObject?
                                //swift
                                endDate = dateFormatterDeny.string(from: dateGetEnd!) as AnyObject?

                                self.dict["multilateralId"] = multilateralId
                                self.dict["fileName"]       = fileName
                                self.dict["iniDate"]        = iniDate
                                self.dict["endDate"]        = endDate
                                self.dict["URLName"]        = URLName as AnyObject?
                                
                                var multilateralIdParsed = UserDefaults.standard.object(forKey: "tempMultilateralId") as! Int
                                
                                if (UserDefaults.standard.object(forKey: "signedMultilateralIds") == nil){
                                    UserDefaults.standard.set(String(multilateralIdParsed), forKey: "signedMultilateralIds")
                                    UserDefaults.standard.set(String(position), forKey: "signedMultilateralIdsURLPosition")
                                    UserDefaults.standard.synchronize()
                                    print(UserDefaults.standard.object(forKey: "signedMultilateralIds") as! String)
                                }
                                else{
                                    var signedMultilateralIds           = UserDefaults.standard.object(forKey: "signedMultilateralIds") as! String
                                    var positionsList                   = UserDefaults.standard.object(forKey: "signedMultilateralIdsURLPosition") as! String
                                    
                                    
                                    var signedMultilateralIdsArray      = signedMultilateralIds.components(separatedBy: ",")
                                    var URLPositionsArray               = positionsList.components(separatedBy: ",")
                                    URLPositionsArray.append(String(position))
                                    
                                    signedMultilateralIdsArray.append(String(multilateralIdParsed))
                                    
                                    multilateralIdList                  = signedMultilateralIdsArray.joined(separator: ",")
                                    positionsList                       = URLPositionsArray.joined(separator: ",")
                                    
                                    UserDefaults.standard.set(multilateralIdList, forKey: "signedMultilateralIds")
                                    UserDefaults.standard.set(positionsList, forKey: "signedMultilateralIdsURLPosition")
                                    UserDefaults.standard.synchronize()
                                }
                                
                                print ("***********************")
                                print(multilateralIdList)
                                print ("***********************")
                                
                                
                                print("the dict is-\(self.dict)")
                                //swift
                                self.array.append(self.dict as AnyObject)
                                
                            }
                            
                            if (documentsArray.count == 0){
                                self.showAlertMessage("HistoryViewController.notData")
                            }
                        }
                        else{
                            //15/11/2016
                            self.showAlertMessage("HistoryViewController.notData")
                        }
                        
                    }
                        
                    else{
                        print("Response: \(json)")
                        print ("no se ha encontrado ningun registro que coincida")
                    }
                    var counter:Int = UserDefaults.standard.integer(forKey: "HistoryURLPosition")
                    counter += 1
                    UserDefaults.standard.set(counter, forKey: "HistoryURLPosition")
                    UserDefaults.standard.synchronize()
                    print ("HistoryURLPosition")
                    print (counter)
                    self.manageIterations()
                }
                else {
                    //swift
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
                
            }
            catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                //swift
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            
            
        })
        
        task.resume()
        
    }
}
