//
//  DeniedViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 19/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//
/*
 import UIKit
 
 class DeniedViewController: UIViewController {
 
 @IBOutlet weak var dateLabel: UILabel!
 @IBOutlet weak var fromTextField: UITextField!
 @IBOutlet weak var fromCalendarImage: UIImageView!
 
 @IBOutlet weak var toTextField: UITextField!
 @IBOutlet weak var toCalendarImage: UIImageView!
 
 @IBOutlet weak var searchButton: UIButton!
 
 @IBOutlet weak var tableView: UITableView!
 
 var datePickerView: DatePicker!
 var opened: Bool = false
 
 var currentTextField: UITextField?
 
 let cellIdentifier = "HistoryDocTableViewCell"
 let cellExpIdentifier = "HistoryDocExpTableViewCell"
 
 /// The data source
 var dataSource: [Document]! = []
 
 //Global Documents Array, Dictionary and B64 Document initialization
 
 var array = Array<AnyObject>()
 var dict = Dictionary<String, AnyObject>()
 var base64Document  = ""
 var iniDateString   = ""
 var endDateString   = ""
 var auxiliarCounter = 0
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 initializeTableView()
 
 initializeDataSource()
 
 setUpUI()
 NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(initializeTableView),name: "CallWSReceiptGetCancel" ,object: nil)
 NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(initializeDataSource),name: "CallWSReceiptGetCancel" ,object: nil)
 NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(CallWSGetHistoryDenied),name: "CallWSGetHistoryDenied" ,object: nil)
 }
 
 override func viewDidAppear(animated: Bool) {
 super.viewDidAppear(animated)
 setUpDatePicker()
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 func setUpUI() {
 searchButton.setTitle(NSLocalizedString("SignedViewController.search", comment: "").uppercaseString, forState: .Normal)
 searchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
 Utils.setColor(UIColor(hexString:AppConstants.Color.BUTTON_GREEN), forState: .Normal, button: searchButton)
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
 datePickerView = NSBundle.mainBundle().loadNibNamed("DatePicker", owner: self, options: nil)[0] as! DatePicker
 datePickerView.frame = CGRectMake(0, view.frame.height, view.frame.size.width, datePickerView.frame.height)
 datePickerView.delegate = self
 
 datePickerView.doneBarButton.title = NSLocalizedString("DatePicker.done", comment: "")
 datePickerView.removeBarButton.title = NSLocalizedString("DatePicker.remove", comment: "")
 
 view.addSubview(datePickerView)
 }
 
 @IBAction func datePickerBeginAction(sender: UITextField) {
 currentTextField = sender
 datePickerView.tag = sender.tag
 if !opened {
 presentPicker(datePickerView)
 }
 }
 
 func presentPicker (menuView: UIView) {
 opened = true
 UIView.animateWithDuration(0.6) { () -> Void in
 menuView.frame = CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y - menuView.frame.size.height, menuView.frame.width, menuView.frame.size.height)
 }
 
 }
 
 func dismissPicker() {
 if opened {
 UIView.animateWithDuration(1.0) { () -> Void in
 self.datePickerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.height, self.view.frame.width, self.datePickerView.frame.height)
 }
 }
 opened = false
 
 }
 
 override func viewWillDisappear(animated: Bool) {
 super.viewWillDisappear(animated)
 dismissPicker()
 }
 
 
 
 }
 
 // TableView Helper Methods
 extension DeniedViewController {
 func showAlertMessage(alertMessage:String){
 dispatch_async(dispatch_get_main_queue(), {
 let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .Alert)
 alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .Default, handler: nil))
 self.presentViewController(alertViewController, animated: true, completion: nil)
 return
 })
 
 }
 
 func initializeTableView() {
 tableView.bounces = false
 tableView.style
 tableView.separatorStyle = .None
 self.tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
 self.tableView.registerNib(UINib(nibName: cellExpIdentifier, bundle: nil), forCellReuseIdentifier: cellExpIdentifier)
 
 }
 
 func initializeDataSource() {
 
 dataSource = []
 
 for documentInfo in self.array {
 
 var fileName        = documentInfo["fileName"] as! String
 var endDate         = documentInfo["endDate"] as! String
 var iniDate         = documentInfo["iniDate"] as! String
 var multilateralId  = documentInfo["multilateralId"] as! Int
 var reason          = documentInfo["reasonCancelDocument"] as! String
 var URLName         = documentInfo["URLName"] as! String
 
 var document = Document(name: fileName, dateIni: iniDate, dateEnd: endDate , size: 0.0, url: URLName, location: "XXXXX", obs: reason, multilateralId: multilateralId, state: State.Collapsed)
 dataSource.append(document)
 /* No borrar, me muestra algo importante
 let document = Document(name: "Documento "+index.description, dateIni: "24/03/1987", dateEnd: "24/03/1987", size: 13.0, url: "Nominas", location: "XXXXX", obs: "El documento se declina ya que los datos escritos dentro del mismo no correspondena los que se describenn el contrato inicial, favor de corregir.", state: State.Collapsed)
 dataSource.append(document)*/
 
 }
 dispatch_async(dispatch_get_main_queue()){
 self.tableView.dataSource = self
 self.tableView.reloadData()
 }
 }
 
 func configureCell(cell: HistoryDocTableViewCell, document: Document) {
 cell.selectionStyle = UITableViewCellSelectionStyle.None
 
 let dateIni = NSLocalizedString("SignedViewController.date_ini", comment: "")
 let dateEnd = NSLocalizedString("SignedViewController.date_end", comment: "")
 let url = NSLocalizedString("SignedViewController.url", comment: "")
 let size = NSLocalizedString("SignedViewController.size", comment: "")
 
 cell.nameLabel.text = document.name
 cell.dateIniLabel.text = dateIni + ":" + document.dateIni
 cell.dateEndLabel.text = dateEnd + ":" + document.dateEnd
 cell.urlName.text = url + ":" + document.url
 cell.sizeLabel.text = size + ":" + document.size.description + "Kb"
 
 cell.nameLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE_BOLD
 cell.dateIniLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.dateEndLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.urlName.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.sizeLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.showLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 
 
 if document.state == State.Collapsed {
 cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.dateIniLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.dateEndLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.urlName.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.sizeLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.showLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.showButton.setImage(UIImage(named: "icon-show"), forState: .Normal)
 cell.calendarImage.image = UIImage(named: "icon-calendar")
 
 cell.contentView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_DOC)
 } else {
 cell.nameLabel.textColor = UIColor.whiteColor()
 cell.dateIniLabel.textColor = UIColor.whiteColor()
 cell.dateEndLabel.textColor = UIColor.whiteColor()
 cell.urlName.textColor = UIColor.whiteColor()
 cell.sizeLabel.textColor = UIColor.whiteColor()
 cell.showLabel.textColor = UIColor.whiteColor()
 cell.showButton.setImage(UIImage(named: "icon-show-white"), forState: .Normal)
 cell.calendarImage.image = UIImage(named: "icon-calendar-white")
 
 cell.contentView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_DOC_SELECTED)
 }
 }
 
 func configureCellExp(cell: HistoryDocExpTableViewCell, document: Document) {
 cell.selectionStyle = UITableViewCellSelectionStyle.None
 
 let dateIni = NSLocalizedString("SignedViewController.date_ini", comment: "")
 let dateEnd = NSLocalizedString("SignedViewController.date_end", comment: "")
 let url = NSLocalizedString("SignedViewController.url", comment: "")
 let size = NSLocalizedString("SignedViewController.size", comment: "")
 let obs = NSLocalizedString("SignedViewController.obs", comment: "")
 
 cell.nameLabel.text = document.name
 cell.dateIniLabel.text = dateIni + ":" + document.dateIni
 cell.dateEndLabel.text = dateEnd + ":" + document.dateEnd
 cell.urlName.text = url + ":" + document.url
 cell.sizeLabel.text = size + ":" + document.size.description + "Kb"
 cell.obsLabel.text = obs + ":" + document.obs
 
 cell.nameLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE_BOLD
 cell.dateIniLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.dateEndLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.urlName.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.sizeLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.showLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 cell.obsLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
 
 
 if document.state == State.Collapsed {
 cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.dateIniLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.dateEndLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.urlName.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.sizeLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.showLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.obsLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
 cell.showButton.setImage(UIImage(named: "icon-show"), forState: .Normal)
 cell.calendarImage.image = UIImage(named: "icon-calendar")
 
 cell.contentView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_DOC)
 } else {
 cell.nameLabel.textColor = UIColor.whiteColor()
 cell.dateIniLabel.textColor = UIColor.whiteColor()
 cell.dateEndLabel.textColor = UIColor.whiteColor()
 cell.urlName.textColor = UIColor.whiteColor()
 cell.sizeLabel.textColor = UIColor.whiteColor()
 cell.showLabel.textColor = UIColor.whiteColor()
 cell.obsLabel.textColor = UIColor.whiteColor()
 cell.showButton.setImage(UIImage(named: "icon-show-white"), forState: .Normal)
 cell.calendarImage.image = UIImage(named: "icon-calendar-white")
 
 cell.contentView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_DOC_SELECTED)
 }
 }
 /**
 Deselects all the rows except the indexpath passed
 
 - parameter index: index not deselected
 */
 func deselectRows(index: Int) {
 for (i,document) in dataSource.enumerate() {
 if i != index {
 var documentReplace = document
 documentReplace.state = State.Collapsed
 dataSource[i] = documentReplace
 }
 }
 }
 
 }
 
 extension DeniedViewController: UITableViewDataSource {
 func numberOfSectionsInTableView(tableView: UITableView) -> Int {
 return 1
 }
 
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return dataSource.count
 }
 
 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
 let document = dataSource[indexPath.row]
 
 if document.state == State.Collapsed {
 let cell: HistoryDocTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryDocTableViewCell
 
 cell.indexPath = indexPath
 cell.delegate = self
 
 configureCell(cell, document: dataSource[indexPath.row])
 
 return cell
 } else {
 let cell: HistoryDocExpTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellExpIdentifier, forIndexPath: indexPath) as! HistoryDocExpTableViewCell
 
 cell.indexPath = indexPath
 cell.delegate = self
 
 configureCellExp(cell, document: dataSource[indexPath.row])
 
 return cell
 }
 
 }
 }
 extension DeniedViewController: UITableViewDelegate {
 func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
 var document = dataSource[indexPath.row]
 if document.state == State.Collapsed {
 document.state = State.Expanded
 } else {
 document.state = State.Collapsed
 }
 dataSource[indexPath.row] = document
 
 deselectRows(indexPath.row)
 tableView.reloadData()
 
 }
 
 func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
 let document = dataSource[indexPath.row]
 if document.state == State.Collapsed {
 return 55.0 + 3.0
 } else {
 return 105.0 + 3.0
 }
 
 }
 
 func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
 let additionalSeparatorThickness = CGFloat(3)
 let additionalSeparator = UIView(frame: CGRectMake(0,
 cell.frame.size.height - additionalSeparatorThickness,
 cell.frame.size.width,
 additionalSeparatorThickness))
 additionalSeparator.backgroundColor = UIColor.whiteColor()
 cell.addSubview(additionalSeparator)
 }
 }
 
 extension DeniedViewController: HistoryCellProtocol {
 func viewDocument(indexPath: NSIndexPath) {
 let viewerViewController = ViewerViewController(nibName: "ViewerViewController", bundle: nil)
 viewerViewController.document = dataSource[indexPath.row]
 
 self.navigationController?.pushViewController(viewerViewController, animated: true)
 }
 }
 
 extension DeniedViewController : DatePickerDelegate {
 
 func removePressed() {
 if datePickerView.tag == 0 {
 fromTextField.text = nil
 } else {
 toTextField.text = nil
 }
 }
 
 func donePressed() {
 dismissPicker()
 }
 
 func getURLListSize()->Int{
 var URLList         = NSUserDefaults.standardUserDefaults().objectForKey("URL") as! String
 var URLArray        = URLList.componentsSeparatedByString(",")
 return URLArray.count
 }
 func getURLInformationFromPosition (position:Int)->(String,String,String,String,String){
 var URLList         = NSUserDefaults.standardUserDefaults().objectForKey("URL") as! String
 var URLNamesList    = NSUserDefaults.standardUserDefaults().objectForKey("URLName") as! String
 var idsDomainList   = NSUserDefaults.standardUserDefaults().objectForKey("URLIdDomainList") as! String
 var idsEmpList      = NSUserDefaults.standardUserDefaults().objectForKey("URLIdEmpList") as! String
 var idsRhList       = NSUserDefaults.standardUserDefaults().objectForKey("URLIdRhList") as! String
 
 var URLArray        = URLList.componentsSeparatedByString(",")
 var URLNamesArray   = URLNamesList.componentsSeparatedByString(",")
 var idsDomainArray = idsDomainList.componentsSeparatedByString(",")
 var idsEmpArray     = idsEmpList.componentsSeparatedByString(",")
 var idsRhArray      = idsRhList.componentsSeparatedByString(",")
 
 return (URLArray[position], URLNamesArray[position], idsDomainArray[position], idsEmpArray[position], idsRhArray[position])
 }
 
 func manageIterations(){
 var size    = getURLListSize()
 var counter = 0
 
 if(NSUserDefaults.standardUserDefaults().objectForKey("HistoryURLPosition") != nil){
 counter = NSUserDefaults.standardUserDefaults().objectForKey("HistoryURLPosition") as! Int
 }
 
 else{
 NSUserDefaults.standardUserDefaults().setObject(counter, forKey: "HistoryURLPosition")
 NSUserDefaults.standardUserDefaults().synchronize()
 }
 
 if (counter == size){
 print("llegue al limite")
 NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "HistoryURLPosition")
 NSUserDefaults.standardUserDefaults().synchronize()
 NSNotificationCenter.defaultCenter().postNotificationName("CallWSReceiptGetCancel", object: nil)
 }
 else{
 if(NSUserDefaults.standardUserDefaults().objectForKey("HistoryURLPosition") != nil){
 counter = NSUserDefaults.standardUserDefaults().objectForKey("HistoryURLPosition") as! Int
 var response = getURLInformationFromPosition(counter)
 CallWSGetHistoryDenied(counter, URL: response.0, URLName: response.1, idDomain: response.2, idEmp: response.3, idRhEmp: response.4)
 }
 }
 }
 
 func datePickerValueChanged(date: NSDate) {
 
 print("date picker change")
 let dateFormatter = NSDateFormatter()
 let dateFormatterString = NSDateFormatter()
 dateFormatter.dateFormat = "dd/MM/yyyy"
 dateFormatterString.dateFormat = "MMM d, yyyy"
 dateFormatterString.shortMonthSymbols = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul","Aug","Sep","Oct", "Nov","Dec"]
 
 if datePickerView.tag == 0 {
 print("date picker change format 1")
 fromTextField.text = dateFormatter.stringFromDate(date)
 print (fromTextField.text!)
 var iniDatePicker = dateFormatterString.stringFromDate(date)
 print(iniDatePicker)
 
 iniDateString = iniDatePicker + " 0:00:00 AM"
 
 } else {
 print("date picker change format 2")
 toTextField.text = dateFormatter.stringFromDate(date)
 print (toTextField.text!)
 var endDatePicker = dateFormatterString.stringFromDate(date)
 print(endDatePicker)
 endDateString = endDatePicker + " 11:59:00 PM"
 }
 }
 
 @IBAction func searchDeniedHistory(sender: UIButton) {
 /*auxiliarCounter = 0
 CallWSGetHistoryDenied()*/
 print ("Hola, presionaste el boton de busqueda")
 self.array = []
 NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "HistoryURLPosition")
 
 print ("iniDateString")
 print (iniDateString)
 print ("endDateString")
 print (endDateString)
 
 if (fromTextField.text != "" && toTextField.text != ""){
 if ((iniDateString.compare(endDateString) == NSComparisonResult.OrderedDescending) || (iniDateString.compare(endDateString) == NSComparisonResult.OrderedSame)){
 showAlertMessage("SignedViewController.FirstDateAlert")
 }
 else{
 manageIterations()
 
 }
 }
 else{
 if(fromTextField.text == "" && toTextField.text == ""){
 manageIterations()
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
 
 func CallWSGetHistoryDenied(position: Int, URL:String, URLName:String, idDomain:String, idEmp:String ,idRhEmp:String){
 print ("callwsGetHistory")
 let dateFormatterDeny = NSDateFormatter()
 var path       = URL+"/WS_Rest_HRV/rest/receipt/get"
 let session     = NSURLSession.sharedSession()
 
 print ("idRH")
 print (idRhEmp)
 print ("idDomain")
 print (idDomain)
 var emptyParameter  = ""
 print ("emptyParameter")
 print (emptyParameter)
 var statusReceipt   = "CANCELADOS"
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
 
 let request = NSMutableURLRequest(URL: NSURL(string:path)!)
 request.HTTPMethod = "POST"
 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 request.addValue("application/json", forHTTPHeaderField: "Accept")
 request.HTTPBody = JSONObject.dataUsingEncoding(NSUTF8StringEncoding)
 let task = session.dataTaskWithRequest(request) { data, response, error in
 guard data != nil else {
 print("no data found: \(error)")
 return
 }
 
 do {
 print ("entre 1er do")
 if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
 if (json["resultado"]as? Int != 0){
 print ("entre 2do paso ")
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
 var reason = document["reasonCancelDocument"]
 
 dateFormatterDeny.locale = NSLocale(localeIdentifier: "en_US")
 dateFormatterDeny.dateFormat = "MMM d, yyyy HH:mm:ss a"
 
 var dateGet = dateFormatterDeny.dateFromString(iniDate as! String)
 var dateGetEnd = dateFormatterDeny.dateFromString(endDate as! String)
 
 dateFormatterDeny.dateFormat = "dd/MM/YYYY"
 
 iniDate = dateFormatterDeny.stringFromDate(dateGet!)
 endDate = dateFormatterDeny.stringFromDate(dateGetEnd!)
 //holi
 self.dict["multilateralId"] = multilateralId
 self.dict["fileName"]       = fileName
 self.dict["iniDate"]        = iniDate
 self.dict["endDate"]        = endDate
 self.dict["URLName"]        = URLName
 self.dict["reasonCancelDocument"] = reason
 
 print("the dict is-\(self.dict)")
 self.array.append(self.dict)
 
 }
 /*
 
 */
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
 var counter = NSUserDefaults.standardUserDefaults().objectForKey("HistoryURLPosition") as! Int
 counter += 1
 NSUserDefaults.standardUserDefaults().setObject(counter, forKey: "HistoryURLPosition")
 NSUserDefaults.standardUserDefaults().synchronize()
 print ("HistoryURLPosition")
 print (counter)
 self.manageIterations()
 }
 else {
 let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
 print("Error could not parse JSON: \(jsonStr)")
 }
 
 }
 catch let parseError {
 print(parseError)// Log the error thrown by `JSONObjectWithData`
 let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
 print("Error could not parse JSON: '\(jsonStr)'")
 }
 
 
 }
 
 task.resume()
 iniDateString = ""
 endDateString = ""
 
 /*
 var URLList         = NSUserDefaults.standardUserDefaults().objectForKey("URL") as! String
 var URLNamesList    = NSUserDefaults.standardUserDefaults().objectForKey("URLName") as! String
 var idDomainList    = NSUserDefaults.standardUserDefaults().objectForKey("URLIdDomainList") as! String
 var idRhList        = NSUserDefaults.standardUserDefaults().objectForKey("URLIdRhList")  as! String
 
 var idDomainArray=[String]() , idRhArray=[String]()
 
 if ((URLList.characters.last!) == ","){
 
 URLList           = (URLList as NSString).stringByReplacingCharactersInRange(NSRange(location: URLList.characters.count - 1, length: 1), withString: "")
 URLNamesList      = (URLNamesList as NSString).stringByReplacingCharactersInRange(NSRange(location: URLNamesList.characters.count - 1, length: 1), withString: "")
 }
 
 var fullURLArr      = URLList.componentsSeparatedByString(",")
 var fullNameArr     = URLNamesList.componentsSeparatedByString(",")
 
 var URLArraySize    =  fullURLArr.count
 if (URLArraySize>1){
 idDomainArray   = idDomainList.componentsSeparatedByString(",")
 idRhArray       = idRhList.componentsSeparatedByString(",")
 
 }
 else{
 idDomainArray.append(idDomainList)
 idRhArray.append(idRhList)
 }
 
 if (auxiliarCounter < URLArraySize){
 var path     = fullURLArr[auxiliarCounter]
 var namePath = fullURLArr[auxiliarCounter]
 var idDomain = idDomainArray [auxiliarCounter]
 var idRhEmp  = idRhArray [auxiliarCounter]
 
 let session  = NSURLSession.sharedSession()
 let request  = NSMutableURLRequest(URL: NSURL(string:path)!)
 let dateFormatterDeny = NSDateFormatter()
 
 var statusReceipt   = "CANCELADOS"
 var iniDate         = "Aug 3, 1999 3:47:15 PM"
 var endDate         = "Dec 3, 2025 3:47:15 PM"
 var result          = 1
 
 array = []
 if (iniDateString != ""){
 iniDate = iniDateString
 }
 if (endDateString != ""){
 endDate = endDateString
 }
 
 request.HTTPMethod = "POST"
 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 request.addValue("application/json", forHTTPHeaderField: "Accept")
 
 
 let JSONObject  =  "{\"idDomain\":\(idDomain),\"idRhEmp\":\"\(idRhEmp)\",\"statusReceipt\":\"\(statusReceipt)\",\"iniDate\":\"\(iniDate)\",\"endDate\":\"\(endDate)\",\"userDomain\":\"\",\"passwordDomain\":\"\",\"resultado\":\(1)}"
 print ("Parametros Enviados:")
 print(JSONObject)
 
 
 request.HTTPBody = JSONObject.dataUsingEncoding(NSUTF8StringEncoding)
 let task = session.dataTaskWithRequest(request) { data, response, error in
 guard data != nil else {
 print("no data found: \(error)")
 return
 }
 
 do {
 
 if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
 if (json["resultado"]as? Int != 0){
 
 print("Response: \(json)")
 print ("Response lstReceipts :\(json["lstReceipts"])")
 
 if var documentsArray = json["lstReceipts"] as? [[String: AnyObject]] {
 for document in documentsArray{
 var docType     = document["docType"]
 var iniDate     = document["iniDate"]
 var endDate     = document["endDate"]
 var fileName    = document["fileName"]
 var signDate    = document["signDate"]
 var multilateralId = document["multilateralId"]
 
 
 dateFormatterDeny.locale = NSLocale(localeIdentifier: "en_US")
 dateFormatterDeny.dateFormat = "MMM d, yyyy HH:mm:ss a"
 
 var dateGet = dateFormatterDeny.dateFromString(iniDate as! String)
 var dateGetEnd = dateFormatterDeny.dateFromString(endDate as! String)
 
 dateFormatterDeny.dateFormat = "dd/MM/YYYY"
 
 iniDate = dateFormatterDeny.stringFromDate(dateGet!)
 endDate = dateFormatterDeny.stringFromDate(dateGetEnd!)
 
 self.dict["multilateralId"] = multilateralId
 self.dict["fileName"]       = fileName
 self.dict["iniDate"]        = iniDate
 self.dict["endDate"]        = endDate
 self.dict["base64Document"] = self.base64Document
 print("the dict is-\(self.dict)")
 self.array.append(self.dict)
 
 }
 
 self.iniDateString = ""
 self.endDateString = ""
 if (self.auxiliarCounter < URLArraySize){
 NSNotificationCenter.defaultCenter().postNotificationName("CallWSGetHistoryDenied", object: nil)
 self.auxiliarCounter += 1
 }
 else {
 NSNotificationCenter.defaultCenter().postNotificationName("CallWSReceiptGetCancel", object: nil)
 self.auxiliarCounter = 0
 }
 }
 else{
 print ("No hay datos")
 }
 }
 else{
 print("Response: \(json)")
 print ("no se ha encontrado ningun registro que coincida")
 }
 }
 else {
 let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
 print("Error could not parse JSON: \(jsonStr)")
 }
 }
 catch let parseError {
 print(parseError)// Log the error thrown by `JSONObjectWithData`
 let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
 print("Error could not parse JSON: '\(jsonStr)'")
 }
 
 }
 
 task.resume()
 }
 */
 }
 
 }*/
//
//  DeniedViewController.swift
//  FirmApp
//
//  Created by mikel.sanchez.local on 19/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class DeniedViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var fromCalendarImage: UIImageView!
    
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var toCalendarImage: UIImageView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var datePickerView: DatePicker!
    var opened: Bool = false
    
    var currentTextField: UITextField?
    
    let cellIdentifier = "HistoryDocTableViewCell"
    let cellExpIdentifier = "HistoryDocExpTableViewCell"
    
    /// The data source
    var dataSource: [Document]! = []
    
    //Global Documents Array, Dictionary and B64 Document initialization
    
    var array = Array<AnyObject>()
    var dict = Dictionary<String, AnyObject>()
    var base64Document  = ""
    var iniDateString   = ""
    var endDateString   = ""
    var auxiliarCounter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        
        initializeDataSource()
        
        setUpUI()
        NotificationCenter.default.addObserver(self,selector: #selector(initializeTableView),name: NSNotification.Name(rawValue: "CallWSReceiptGetCancel") ,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(initializeDataSource),name: NSNotification.Name(rawValue: "CallWSReceiptGetCancel") ,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(searchDeniedHistory),name: NSNotification.Name(rawValue: "CallWSGetHistoryDenied") ,object: nil)
        manageIterations()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchDeniedHistory(_ sender: Any) {
    //}
    //@IBAction func searchDeniedHistory(_ sender: UIButton) {
        /*auxiliarCounter = 0
         CallWSGetHistoryDenied()*/
        
        print ("Hola, presionaste el boton de busqueda")
        self.array = []
        UserDefaults.standard.removeObject(forKey: "HistoryURLPosition")
        
        print ("iniDateString")
        print (iniDateString)
        print ("endDateString")
        print (endDateString)
        if (fromTextField.text != "" && toTextField.text != ""){
            if ((iniDateString.compare(endDateString) == ComparisonResult.orderedDescending)){
                // || (iniDateString.compare(endDateString) == NSComparisonResult.OrderedSame)
                showAlertMessage("SignedViewController.FirstDateAlert")
            }
            else{
                manageIterations()
                UserDefaults.standard.removeObject(forKey: "deniedMultilateralIds")
                UserDefaults.standard.synchronize()
            }
        }
        else{
            if(fromTextField.text == "" && toTextField.text == ""){
                manageIterations()
                UserDefaults.standard.removeObject(forKey: "deniedMultilateralIds")
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
    
    
    
}

// TableView Helper Methods
extension DeniedViewController {
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
        self.tableView.register(UINib(nibName: cellExpIdentifier, bundle: nil), forCellReuseIdentifier: cellExpIdentifier)
        
    }
    
    func initializeDataSource() {
        
        dataSource = []
        
        for documentInfo in self.array {
            
            var fileName        = documentInfo["fileName"] as! String
            var endDate         = documentInfo["endDate"] as! String
            var iniDate         = documentInfo["iniDate"] as! String
            var multilateralId  = documentInfo["multilateralId"] as! Int
            var reason          = documentInfo["reasonCancelDocument"] as! String
            var URLName         = documentInfo["URLName"] as! String
            
            var document = Document(name: fileName, dateIni: iniDate, dateEnd: endDate , url: URLName, location: "XXXXX", obs: reason, multilateralId: multilateralId, state: State.collapsed)
            dataSource.append(document)
            
            
            /* No borrar, me muestra algo importante
             let document = Document(name: "Documento "+index.description, dateIni: "24/03/1987", dateEnd: "24/03/1987", size: 13.0, url: "Nominas", location: "XXXXX", obs: "El documento se declina ya que los datos escritos dentro del mismo no correspondena los que se describenn el contrato inicial, favor de corregir.", state: State.Collapsed)
             dataSource.append(document)*/
            
        }
        DispatchQueue.main.async{
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    func configureCell(cell: HistoryDocTableViewCell, document: Document) {
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
    
    func configureCellExp(cell: HistoryDocExpTableViewCell, document: Document) {
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dateIni = NSLocalizedString("SignedViewController.date_ini", comment: "")
        let dateEnd = NSLocalizedString("SignedViewController.date_end", comment: "")
        let url = NSLocalizedString("SignedViewController.url", comment: "")
        let size = NSLocalizedString("SignedViewController.size", comment: "")
        let obs = NSLocalizedString("SignedViewController.obs", comment: "")
        
        cell.nameLabel.text = document.name
        cell.dateIniLabel.text = dateIni + ":" + document.dateIni
        cell.dateEndLabel.text = dateEnd + ":" + document.dateEnd
        cell.urlName.text = url + ":" + document.url
        //cell.sizeLabel.text = size + ":" + document.size.description + "Kb"
        cell.obsLabel.text = obs + ":" + document.obs
        
        cell.nameLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE_BOLD
        cell.dateIniLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.dateEndLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.urlName.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.sizeLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.showLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.obsLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        
        
        if document.state == State.collapsed {
            cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.dateIniLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.dateEndLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.urlName.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.sizeLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.showLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
            cell.obsLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
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
            cell.obsLabel.textColor = UIColor.white
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
            else{
                print (document.multilateralId)
            }
        }
    }
    
}

extension DeniedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = dataSource[indexPath.row]
        
        if document.state == State.collapsed {
            let cell: HistoryDocTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryDocTableViewCell
            
            cell.indexPath = indexPath
            cell.delegate = self
            
            configureCell(cell: cell, document: dataSource[indexPath.row])
            
            return cell
        } else {
            let cell: HistoryDocExpTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellExpIdentifier, for: indexPath) as! HistoryDocExpTableViewCell
            
            cell.indexPath = indexPath
            cell.delegate = self
            
            configureCellExp(cell: cell, document: dataSource[indexPath.row])
            
            return cell
        }
        
    }
}
extension DeniedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var document = dataSource[indexPath.row]
        if document.state == State.collapsed {
            document.state = State.expanded
        } else {
            document.state = State.collapsed
        }
        dataSource[indexPath.row] = document
        
        deselectRows(indexPath.row)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let document = dataSource[indexPath.row]
        if document.state == State.collapsed {
            return 55.0 + 3.0
        } else {
            return 105.0 + 3.0
        }
        
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

extension DeniedViewController: HistoryCellProtocol {
    func viewDocument(_ indexPath: IndexPath) {
        let viewerViewController = ViewerViewController(nibName: "ViewerViewController", bundle: nil)
        viewerViewController.document = dataSource[indexPath.row]
        
        self.navigationController?.pushViewController(viewerViewController, animated: true)
    }
}

extension DeniedViewController : DatePickerDelegate {
    
    func removePressed() {
        if datePickerView.tag == 0 {
            fromTextField.text = nil
        } else {
            toTextField.text = nil
        }
    }
    
    func donePressed() {
        dismissPicker()
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
        var idsDomainArray = idsDomainList.components(separatedBy: ",")
        var idsEmpArray     = idsEmpList.components(separatedBy: ",")
        var idsRhArray      = idsRhList.components(separatedBy: ",")
        
        return (URLArray[position], URLNamesArray[position], idsDomainArray[position], idsEmpArray[position], idsRhArray[position])
    }
    
    func manageIterations(){
        let size    = getURLListSize()
        var counter: Int = 0
        
        if(UserDefaults.standard.object(forKey: "HistoryURLPosition") != nil){
            counter = UserDefaults.standard.integer(forKey: "HistoryURLPosition")
        }
            
        else{
            UserDefaults.standard.set(counter, forKey: "HistoryURLPosition")
            UserDefaults.standard.synchronize()
        }
        
        if (counter == size){
            print("llegue al limite")
            UserDefaults.standard.set(nil, forKey: "HistoryURLPosition")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSReceiptGetCancel"), object: nil)
            
        }
        else{
            if(UserDefaults.standard.object(forKey: "HistoryURLPosition") != nil){
                counter = UserDefaults.standard.integer(forKey: "HistoryURLPosition")
                
                let response = getURLInformationFromPosition(counter)
                CallWSGetHistoryDenied(counter, URL: response.0, URLName: response.1, idDomain: response.2, idEmp: response.3, idRhEmp: response.4)
            }
        }
    }
    
    func datePickerValueChanged(_ date: Date) {
        
        print("date picker change")
        let dateFormatter = DateFormatter()
        let dateFormatterString = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatterString.dateFormat = "MMM d, yyyy"
        dateFormatterString.shortMonthSymbols = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul","Aug","Sep","Oct", "Nov","Dec"]
        
        if datePickerView.tag == 0 {
            print("date picker change format 1")
            iniDateString = ""
            fromTextField.text = ""
            fromTextField.text = dateFormatter.string(from: date)
            print (fromTextField.text!)
            let iniDatePicker = dateFormatterString.string(from: date)
            print(iniDatePicker)
            iniDateString = iniDatePicker + " 00:00:00 AM"
            
            
        } else {
            print("date picker change format 2")
            endDateString = ""
            toTextField.text = ""
            
            toTextField.text = dateFormatter.string(from: date)
            print (toTextField.text!)
            let endDatePicker = dateFormatterString.string(from: date)
            print(endDatePicker)
            endDateString = endDatePicker + " 11:59:00 PM"
        }
    }
    
    @IBAction func searchDeniedFiles(_ sender: UIButton) {
        /*auxiliarCounter = 0
         CallWSGetHistoryDenied()*/
        
        print ("Hola, presionaste el boton de busqueda")
        self.array = []
        UserDefaults.standard.removeObject(forKey: "HistoryURLPosition")
        
        print ("iniDateString")
        print (iniDateString)
        print ("endDateString")
        print (endDateString)
        if (fromTextField.text != "" && toTextField.text != ""){
            if ((iniDateString.compare(endDateString) == ComparisonResult.orderedDescending)){
                // || (iniDateString.compare(endDateString) == NSComparisonResult.OrderedSame)
                showAlertMessage("SignedViewController.FirstDateAlert")
            }
            else{
                manageIterations()
                UserDefaults.standard.removeObject(forKey: "deniedMultilateralIds")
                UserDefaults.standard.synchronize()
            }
        }
        else{
            if(fromTextField.text == "" && toTextField.text == ""){
                manageIterations()
                UserDefaults.standard.removeObject(forKey: "deniedMultilateralIds")
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
    
    func CallWSGetHistoryDenied(_ position: Int, URL:String, URLName:String, idDomain:String, idEmp:String ,idRhEmp:String){
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
        var statusReceipt   = "CANCELADOS"
        print ("statusReceipt")
        print (statusReceipt)
        var iniDateAux        = "Aug 3, 1999 3:47:15 PM"
        print ("iniDate")
        print (iniDateAux)
        var endDateAux        = "Dec 3, 2025 3:47:15 PM"
        print ("endDate")
        print (endDateAux)
        var result          = 1
        
        if (iniDateString != ""){
            iniDateAux = iniDateString
        }
        
        if (endDateString != ""){
            endDateAux = endDateString
        }
        
        let JSONObject  =  "{\"idDomain\":\(idDomain),\"idRhEmp\":\(String(describing:idRhEmp)),\"statusReceipt\":\"\(statusReceipt)\",\"iniDate\":\"\(iniDateAux)\",\"endDate\":\"\(endDateAux)\",\"userDomain\":\"\",\"passwordDomain\":\"\",\"resultado\":\(1)}"
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
                print ("entre 1er do")
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                    if (json["resultado"]as? Int != 0){
                        print ("entre 2do paso ")
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
                                var reason = document["reasonCancelDocument"]
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
                                //holi
                                self.dict["multilateralId"] = multilateralId
                                self.dict["fileName"]       = fileName
                                self.dict["iniDate"]        = iniDate
                                self.dict["endDate"]        = endDate
                                //swift
                                self.dict["URLName"]        = URLName as AnyObject?
                                self.dict["reasonCancelDocument"] = reason
                                
                                var multilateralIdParsed = UserDefaults.standard.integer(forKey: "tempMultilateralId")
                                
                                if (UserDefaults.standard.object(forKey: "deniedMultilateralIds") == nil){
                                    UserDefaults.standard.set(String(describing:multilateralIdParsed), forKey: "deniedMultilateralIds")
                                    UserDefaults.standard.set(String(describing:position), forKey: "deniedMultilateralIdsURLPosition")
                                    UserDefaults.standard.synchronize()
                                    print(UserDefaults.standard.object(forKey: "deniedMultilateralIds") as! String)
                                }
                                else{
                                    var deniedMultilateralIds :String = UserDefaults.standard.object(forKey: "deniedMultilateralIds") as! String
                                    
                                    var positionsList                   = UserDefaults.standard.object(forKey: "deniedMultilateralIdsURLPosition") as! String
                                    
                                    var deniedMultilateralIdsArray      = deniedMultilateralIds.components(separatedBy: ",")
                                    var URLPositionsArray      = positionsList.components(separatedBy: ",")
                                    URLPositionsArray.append(String(position))
                                    deniedMultilateralIdsArray.append(String(multilateralIdParsed))
                                    
                                    multilateralIdList                  = deniedMultilateralIdsArray.joined(separator: ",")
                                    positionsList                       = URLPositionsArray.joined(separator: ",")
                                    
                                    UserDefaults.standard.set(multilateralIdList, forKey: "deniedMultilateralIds")
                                    UserDefaults.standard.set(positionsList, forKey: "deniedMultilateralIdsURLPosition")
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
                    var counter :Int = UserDefaults.standard.integer(forKey: "HistoryURLPosition")
                    counter += 1
                    UserDefaults.standard.set(counter, forKey: "HistoryURLPosition")
                    UserDefaults.standard.synchronize()
                    print ("HistoryURLPosition")
                    print (counter)
                    self.manageIterations()
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
                
            }
            catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            
            
        })
        
        task.resume()
        
    }
    
   
    
}
