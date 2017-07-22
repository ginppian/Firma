//
//  DocumentsViewController.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var addUrlButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var operationBorderView: UIView!
    @IBOutlet weak var operationImageView: UIImageView!
    @IBOutlet weak var operationLabel: UILabel!
    
    @IBOutlet weak var operationInfoHeightConstraint: NSLayoutConstraint!
    
    /// The number of elements in the data source
    var total = 0
    
    /// The identifier for the parent cells.
    let parentCellIdentifier = "URLTableViewCell"
    
    /// The identifier for the child cells.
    let childCellIdentifier = "DocumentTableViewCell"
    
    /// The data source
    var dataSource: [URL]! = []
    
    /// Define wether can exist several cells expanded or not.
    let numberOfCellsExpanded: NumberOfCellExpanded = .one
    
    /// Constant to define the values for the tuple in case of not exist a cell expanded.
    let NoCellExpanded = (-1, -1)
    
    /// The index of the last cell expanded and its parent.
    var lastCellExpanded : (Int, Int)! = (-1, -1)
    
    var actualURL               = ""
    var actualURLName           = ""
    var allDocumentsCount       = 0
    var array                   = Array<AnyObject>()
    var dict                    = Dictionary<String, [Document]>()
    var documentsArrayInfo      = [Document]()
    var multilateralIdArray     : [Document] = []
    
    var counter                 = 0
    var URLPosition             = 0
    
    let session    = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //25/03/2017
        
        initializeTableView()
        setUpUI()
        //initializeDataSource2()
        
        //callLocalURL()
        //getDocumentsArray()
        //initializeDataSource2()
        
        UserDefaults.standard.removeObject(forKey: "URLPosition")
        
        initializeDataSource2()
        
        NotificationCenter.default.addObserver(self, selector: #selector(callLocalURL), name:NSNotification.Name(rawValue: "refreshURLTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(initializeDataSource2), name:NSNotification.Name(rawValue: "prepareDocumentsBeforeSet"), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector (CallWSGetDocument) , name: NSNotification.Name(rawValue: "CallWSGetDocument"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (CallWSCancelDocument) , name: NSNotification.Name(rawValue: "CallWSCancelDocument"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (CallWSGetHash) , name: NSNotification.Name(rawValue: "CallWSGetHash"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        //Hide Operation Status View
        operationInfoHeightConstraint.constant = 0
        
        
        //Add OperationView
        operationBorderView.layer.borderWidth = 1
        operationBorderView.layer.borderColor = UIColor(hexString: AppConstants.Color.OPERATION_INFO_BORDER).cgColor
        operationLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        operationLabel.font = AppConstants.Font.OPEN_SANS_OPERATION_TITLE
        
        //Button Styles
        addUrlButton.setTitle(NSLocalizedString("HistoryViewController.add_url", comment: ""), for: UIControlState())
        addUrlButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
        addUrlButton.setTitleColor(UIColor(hexString: AppConstants.Color.BUTTON_BLUE), for: UIControlState())
        
        historyButton.setTitle(NSLocalizedString("HistoryViewController.history", comment: ""), for: UIControlState())
        historyButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_TABLE_BUTTON_MIDDLE
        historyButton.setTitleColor(UIColor(hexString: AppConstants.Color.BUTTON_BLUE), for: UIControlState())
    }
    
    @IBAction func addUrlButtonTapped(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "temporalAssignedKey") != nil){
            UserDefaults.standard.removeObject(forKey: "temporalAssignedKey")}
        let urlViewController = URLViewController(nibName: "URLViewController", bundle: nil)
        urlViewController.mode = Mode.add
        urlViewController.delegate = self
        self.navigationController?.pushViewController(urlViewController, animated: true)
    }
    
    @IBAction func historyButtonTapped(_ sender: UIButton) {
        let historyViewController = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
        self.navigationController?.pushViewController(historyViewController, animated: true)
    }
    
}

// TableView Helper Methods
extension DocumentsViewController {
    
    func initializeTableView() {
        tableView.bounces = false
        tableView.style
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: parentCellIdentifier, bundle: nil), forCellReuseIdentifier: parentCellIdentifier)
        self.tableView.register(UINib(nibName: childCellIdentifier, bundle: nil), forCellReuseIdentifier: childCellIdentifier)

        
        let urlNominas = URL(state: .collapsed, childs: [], name: "Nóminas", url: "")
        let urlContratos = URL(state: .collapsed, childs: [], name: "Contratos", url: "")
        dataSource.append(urlNominas)
        dataSource.append(urlContratos)

        
    }
    func initializeDataSource() {}
    
    func showAlertMessage(_ alertMessage:String){
        DispatchQueue.main.async(execute: {
            let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
        })
        
    }
    
    func initializeDataSource2() {
        //25/03/2017
        initializeTableView()
        
        print ("/********************************************")
        print ("initializeDataSource")
        
        if (UserDefaults.standard.object(forKey: "URLPosition") != nil){
            print ("No es nill")
            var counter = UserDefaults.standard.integer(forKey: "URLPosition")
            counter += 1
            UserDefaults.standard.set(counter , forKey: "URLPosition")
            UserDefaults.standard.synchronize()
            print ("counter")
            print(counter)
            
            var URLPosition2 = UserDefaults.standard.object(forKey: "URLPosition") as! Int
            print (URLPosition2)
            print ("/********************************************")
        }
            
        else{
            print ("Es nill")
            var URLPosition2 = 0
            UserDefaults.standard.set(URLPosition2, forKey: "URLPosition")
            UserDefaults.standard.synchronize()
            
        }
        
        
        var URLlist         = UserDefaults.standard.object(forKey: "URL") as! String
        var URLNameList     = UserDefaults.standard.object(forKey: "URLName") as! String
        var idsDomainList   = UserDefaults.standard.object(forKey: "URLIdDomainList") as! String
        var idsRhList       = UserDefaults.standard.object(forKey: "URLIdRhList") as! String
        print ("--------------------------")
        print(idsDomainList)
        print(idsRhList)
        print ("--------------------------")
        print ("position failed 0")
        var changeObject    = LoginViewController()
        print ("position failed 0.1")
        var cleanedURLList      = changeObject.cleanString(",",list: URLlist)
        var cleanedURLNameList  = changeObject.cleanString(",",list: URLNameList)
        
        var URLArray        = cleanedURLList.components(separatedBy: ",")
        var URLNamesArray   = cleanedURLNameList.components(separatedBy: ",")
        var idsDomainArray  = String(describing: idsDomainList).components(separatedBy: ",")
        var idsRhArray      = String(describing: idsRhList).components(separatedBy: ",")
        var URLPosition2 = UserDefaults.standard.integer(forKey: "URLPosition")
        print ("tamaño del arreglo ")
        print (URLArray.count)
        if (URLPosition2 < URLArray.count){
            print ("position failed 11")
            print (Int(idsDomainArray[URLPosition2])!)
            print ("position failed 12")
            print (idsRhArray[URLPosition2])
            print ("position failed 12")
            var idDomain2 = idsDomainArray[URLPosition2]
            print (idDomain2)
            var actualURL       = URLArray[URLPosition2]
            var actualURLName   = URLNamesArray[URLPosition2]
            var idRhEmp         = idsRhArray[URLPosition2]
            print("voy a llamar a callWSReceipt")
            callWSReceipt(String (URLPosition2), actualURL:actualURL, actualURLName: actualURLName, idDomain : idDomain2, idRhEmp: idRhEmp)
        }
        else{
            print ("position failed 2")
            initializeTableView()
            //setUpUI()
            callLocalURL()
        }
        
    }
    
    
    fileprivate func expandItemAtIndex(_ index : Int, parent: Int) {
        
        // the data of the childs for the specific parent cell.
        let currentSubItems = self.dataSource[parent].childs
        
        // update the state of the cell.
        self.dataSource[parent].state = .expanded
        
        // position to start to insert rows.
        var insertPos = index + 1
        
        let indexPaths = (0..<currentSubItems.count).map { _ -> IndexPath in
            let indexPath = IndexPath(row: insertPos, section: 0)
            insertPos += 1
            return indexPath
        }
        
        self.total += currentSubItems.count
    }
    
    fileprivate func collapseSubItemsAtIndex(_ index : Int, parent: Int) {
        
        var indexPaths = [IndexPath]()
        
        let numberOfChilds = self.dataSource[parent].childs.count
        
        self.dataSource[parent].state = .collapsed
        
        if numberOfChilds > 0 {
            indexPaths = (index + 1...index + numberOfChilds).map { IndexPath(row: $0, section: 0)}
        }
        
        self.total -= numberOfChilds
    }
    
    
    fileprivate func updateCells(_ parent: Int, index: Int) {
        print("updateCells : parent, index")
        print(parent, index)
        print("Estado")
        print(self.dataSource[parent].state)
        //  MBN: Fixed Problem
        //  Expanded URL to stop the problem it caused I decide to make this comparison to collapse
        //  all childs of the selected URL.
        let state = self.dataSource[parent].state
        print("state")
        print(state)
        
        let makeComparison = UserDefaults.standard.object(forKey: "makeComparison") as! String
        
        if (makeComparison == "true"){
            print("Entre al if")
            print("makeComparison")
            UserDefaults.standard.set("false", forKey: "makeComparison")
            UserDefaults.standard.synchronize()
            switch (self.dataSource[parent].state) {
            case .expanded:
                if self.lastCellExpanded != NoCellExpanded {
                    let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                    self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                    self.lastCellExpanded = NoCellExpanded
                }
                else{
                    print("case .one")
                    self.collapseSubItemsAtIndex(index, parent: parent)
                    self.lastCellExpanded = NoCellExpanded
                }
            default :
                print("not case")
                if self.lastCellExpanded != NoCellExpanded {
                    let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                    self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                    self.lastCellExpanded = NoCellExpanded
                }
            }
        }
        else{
            print("Entre al else")
            switch (self.dataSource[parent].state) {
                
            case .expanded:
                print("case .Expanded")
                self.collapseSubItemsAtIndex(index, parent: parent)
                self.lastCellExpanded = NoCellExpanded
                
            case .collapsed:
                print(".Collapsed")
                switch (numberOfCellsExpanded) {
                case .one:
                    print("case .One")
                    // exist one cell expanded previously
                    if self.lastCellExpanded != NoCellExpanded {
                        print("case .One if ")
                        let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                        
                        self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                        
                        // cell tapped is below of previously expanded, then we need to update the index to expand.
                        if parent > parentOfCellExpanded {
                            print("case .One parent > parentOfCellExpanded ")
                            let newIndex = index - self.dataSource[parentOfCellExpanded].childs.count
                            self.expandItemAtIndex(newIndex, parent: parent)
                            self.lastCellExpanded = (newIndex, parent)
                        }
                        else {
                            print("case .One else parent > parentOfCellExpanded ")
                            self.expandItemAtIndex(index, parent: parent)
                            self.lastCellExpanded = (index, parent)
                        }
                    }
                    else {
                        print("case .One else ")
                        self.expandItemAtIndex(index, parent: parent)
                        self.lastCellExpanded = (index, parent)
                    }
                case .several:
                    print("case .Several")
                    self.expandItemAtIndex(index, parent: parent)
                }
            }
        }
        
    }
    
    fileprivate func findParent(_ index : Int) -> (parent: Int, isParentCell: Bool, actualPosition: Int) {
        
        var position = 0, parent = 0
        guard position < index else { return (parent, true, parent) }
        
        var item = self.dataSource[parent]
        
        repeat {
            
            switch (item.state) {
            case .expanded:
                position += item.childs.count + 1
            case .collapsed:
                position += 1
            }
            
            parent += 1
            
            // if is not outside of dataSource boundaries
            if parent < self.dataSource.count {
                item = self.dataSource[parent]
            }
            
        } while (position < index)
        
        // if it's a parent cell the indexes are equal.
        if position == index {
            return (parent, position == index, position)
        }
        
        item = self.dataSource[parent - 1]
        return (parent - 1, position == index, position - item.childs.count - 1)
    }
}

extension DocumentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let (parent, isParentCell, actualPosition) = findParent(indexPath.row)
        print ("parent, isParentCell, actualPosition")
        print (parent, isParentCell, actualPosition)
        if !isParentCell {
            let cell: DocumentTableViewCell = tableView.dequeueReusableCell(withIdentifier: childCellIdentifier) as! DocumentTableViewCell
            let children = dataSource[parent].childs[indexPath.row - actualPosition - 1]
            cell.indexPath = indexPath
            cell.delegate = self
            
            if dataSource[parent].childs.count == indexPath
                .row - actualPosition {
                cell.separatorView.backgroundColor = UIColor.white
            } else {
                cell.separatorView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD)
            }
            configureCellChildrenCell(cell, parent: children)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: parentCellIdentifier) as! URLTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            let parent = dataSource[parent]
            configureCellParentCell(cell, parent: parent)
            
            return cell
        }
    }
    
    func configureCellParentCell(_ cell: URLTableViewCell, parent: URL) {
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if parent.childs.count == 1 {
            cell.remainingLabel.text = "(" + parent.childs.count.description + " " + NSLocalizedString("URLTableViewController.remaining_one", comment: "") + ")"
        } else if (parent.childs.count > 1) {
            cell.remainingLabel.text = "(" + parent.childs.count.description + " " + NSLocalizedString("URLTableViewController.remaining_several", comment: "") + ")"
        } else {
            cell.remainingLabel.text = ""
        }
        
        cell.nameLabel.text = parent.name
        cell.nameLabel.font = AppConstants.Font.OPEN_SANS_TABLE_HEADER
        
        cell.remainingLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        
        if parent.state == State.collapsed {
            cell.urlView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT)
            cell.separatorView.backgroundColor = UIColor.white
            
            cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT)
            cell.remainingLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT)
            
            //            cell.editButton.setImage(UIImage(named: "icon-edit-white"), forState: .Normal)
            //            cell.deleteButton.setImage(UIImage(named: "icon-trash-white"), forState: .Normal)
        } else {
            cell.urlView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_SELECTED)
            if parent.childs.count > 0 {
                cell.separatorView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_SELECTED)
            }else {
                cell.separatorView.backgroundColor = UIColor.white
            }
            
            
            cell.nameLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT_SELECTED)
            cell.remainingLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_PARENT_TEXT_SELECTED)
            
            //            cell.editButton.setImage(UIImage(named: "icon-edit-gray"), forState: .Normal)
            //            cell.deleteButton.setImage(UIImage(named: "icon-trash-gray"), forState: .Normal)
        }
    }
    
    func configureCellChildrenCell(_ cell: DocumentTableViewCell, parent: Document) {
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.contentView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD)
        cell.documentHeaderView.backgroundColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_HEADER)
        
        cell.documentName.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE_BOLD
        cell.documentName.textColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_HEADER_TEXT)
        cell.documentName.text = parent.name
        
        cell.dateIniLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.dateIniLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_HEADER_TEXT)
        cell.dateIniLabel.text = parent.dateIni
        
        cell.dateEndLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.dateEndLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_HEADER_TEXT)
        cell.dateEndLabel.text = parent.dateEnd
        
        cell.sizeLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.sizeLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_HEADER_TEXT)
        //cell.sizeLabel.text = parent.size.description
        
        cell.signLabel.text = NSLocalizedString("DocumentTableViewCell.sign", comment: "")
        cell.signLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.signLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_TEXT)
        
        cell.denyLabel.text = NSLocalizedString("DocumentTableViewCell.deny", comment: "")
        cell.denyLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.denyLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_TEXT)
        
        cell.showLabel.text = NSLocalizedString("DocumentTableViewCell.show", comment: "")
        cell.showLabel.font = AppConstants.Font.OPEN_SANS_TABLE_TITLE_SUBTITLE
        cell.showLabel.textColor = UIColor(hexString: AppConstants.Color.TABLE_CHILD_TEXT)
        
    }
}

extension DocumentsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let (parent, isParentCell, actualPosition) = findParent(indexPath.row)
        
        guard isParentCell else {
            NSLog("A child was tapped!!!")
            
            // The value of the child is indexPath.row - actualPosition - 1
            NSLog("The value of the child is \(dataSource[parent].childs[indexPath.row - actualPosition - 1])")
            
            return
        }
        
        var parentObj = dataSource[parent]
        //self.tableView.beginUpdates()
        
        if parentObj.childs.count > 0 {
            print("reloadData")
            updateCells(parent, index: indexPath.row)
            tableView.reloadData()
        } else {
            
            let cell: URLTableViewCell = tableView.cellForRow(at: indexPath) as! URLTableViewCell
            parentObj.state = State.expanded
            configureCellParentCell(cell, parent: parentObj)
            parentObj.state = State.collapsed
            UIView.animate(withDuration: 0.1, animations: {
                self.configureCellParentCell(cell, parent: parentObj)
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return findParent(indexPath.row).isParentCell ? 53.0 : 113.0
    }
}

extension DocumentsViewController: DocumentCellProtocol {
    func denyDocument(_ indexPath: IndexPath) {
        let urlPasswordViewController = URLPasswordViewController()
        urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        urlPasswordViewController.delegate = self
        let (parent, isParentCell, actualPosition) = findParent(indexPath.row)
        UserDefaults.standard.set(parent, forKey: "SelectedURL")
        guard isParentCell else {
            urlPasswordViewController.document = dataSource[parent].childs[indexPath.row - actualPosition - 1]
            urlPasswordViewController.mode = Mode.deny
            updateCells(parent, index: indexPath.row)
            self.present(urlPasswordViewController, animated: true, completion: nil)
            tableView.reloadData()
            return
        }
    }
    
    func signDocument(_ indexPath: IndexPath) {
        let urlPasswordViewController = URLPasswordViewController()
        urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        urlPasswordViewController.delegate = self
        let (parent, isParentCell, actualPosition) = findParent(indexPath.row)
        UserDefaults.standard.set(parent, forKey: "SelectedURL")
        guard isParentCell else {
            urlPasswordViewController.document = dataSource[parent].childs[indexPath.row - actualPosition - 1]
            urlPasswordViewController.mode = Mode.sign
            updateCells(parent, index: indexPath.row)
            self.present(urlPasswordViewController, animated: true, completion: nil)
            tableView.reloadData()
            return
        }
        
    }
    
    func viewDocument(_ indexPath: IndexPath) {
        print("func: viewDocument DocumentsViewController.swift")
        UserDefaults.standard.set("true", forKey: "makeComparison")
        UserDefaults.standard.synchronize()
        
        let viewerViewController = ViewerViewController(nibName: "ViewerViewController", bundle: nil)
        let (parent, isParentCell, actualPosition) = findParent(indexPath.row)
        guard isParentCell else {
            print("Padre")
            print(parent)
            print("selected")
            print(actualPosition)
            
            // The value of the child is indexPath.row - actualPosition - 1
            //NSLog("The value of the child is \(dataSource[parent].childs[indexPath.row - actualPosition - 1])")
            print("selected URL parent")
            print(parent)
            viewerViewController.document       = dataSource[parent].childs[indexPath.row - actualPosition - 1]
            let multilateralIdViewDocument      = viewerViewController.document?.multilateralId
            UserDefaults.standard.set(parent, forKey: "SelectedURL")
            UserDefaults.standard.set("normal", forKey: "PDFCall")
            UserDefaults.standard.set(multilateralIdViewDocument, forKey: "temporalMultilateralId")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CallWSGetDocument"), object: nil)
            self.navigationController?.pushViewController(viewerViewController, animated: true)
            return
        }
    }
    
    func editDocument(_ indexPath: IndexPath) {
        print("editDocument")
        let (parent, _, _) = findParent(indexPath.row)
        UserDefaults.standard.set("true", forKey: "makeComparison")
        UserDefaults.standard.set(parent, forKey: "rowToDelete")
        UserDefaults.standard.set(parent, forKey: "rowToUpdate")
        UserDefaults.standard.set(parent, forKey: "SelectedURL")
        UserDefaults.standard.synchronize()
        updateCells(parent, index: indexPath.row)
        let url = dataSource[parent]
        print (url)
        let urlViewController = URLViewController(nibName: "URLViewController", bundle: nil)
        
        urlViewController.mode = Mode.edit
        urlViewController.url = url
        urlViewController.delegate = self
        self.navigationController?.pushViewController(urlViewController, animated: true)
        tableView.reloadData()
    }
    
    func deleteDocument(_ indexPath: IndexPath) {
        print("deleteDocument Function on DocumentsViewController File")
        
        UserDefaults.standard.set("true", forKey: "makeComparison")
        
        let (parent, _, _) = findParent(indexPath.row)
        updateCells(parent, index: indexPath.row)
        let urlPasswordViewController = URLPasswordViewController()
        urlPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        UserDefaults.standard.set(parent, forKey: "rowToDelete")
        UserDefaults.standard.set(parent, forKey: "SelectedURL")
        UserDefaults.standard.synchronize()
        print("deleteDocument Function on DocumentsViewController File 2")
        urlPasswordViewController.url = dataSource[parent]
        urlPasswordViewController.delegate = self
        urlPasswordViewController.mode = Mode.delete
        print("deleteDocument Function on DocumentsViewController File 3")
        self.present(urlPasswordViewController, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func hideOperationView(){
        UIView.animate(withDuration: 2, animations: {
            self.operationInfoHeightConstraint.constant = 0
        })
    }
}

extension DocumentsViewController: ModalProtocolDelegate {
    func modalIsDismissed(_ mode: Mode) {
        if mode == Mode.add {
            operationImageView.image = UIImage(named: "icon-success")
            operationLabel.text = NSLocalizedString("DocumentsViewController.add_success", comment: "")
            //Show Operation Info
            operationInfoHeightConstraint.constant = 50
            initializeTableView()
            initializeDataSource()
            setUpUI()
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(DocumentsViewController.hideOperationView), userInfo: nil, repeats: false)
        } else if mode == Mode.sign {
            operationImageView.image = UIImage(named: "icon-success")
            //operationLabel.text = NSLocalizedString("DocumentsViewController.sign_success", comment: "")
            //Show Operation Info
            //operationInfoHeightConstraint.constant = 50
            
            //NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(DocumentsViewController.hideOperationView), userInfo: nil, repeats: false)
        } else if mode == Mode.deny {
            //operationImageView.image = UIImage(named: "icon-success")
            //operationLabel.text = NSLocalizedString("DocumentsViewController.deny_success", comment: "")
            //Show Operation Info
            operationInfoHeightConstraint.constant = 50
            
            // NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(DocumentsViewController.hideOperationView), userInfo: nil, repeats: false)
        } else if mode == Mode.delete {
            operationImageView.image = UIImage(named: "icon-success")
            operationLabel.text = NSLocalizedString("DocumentsViewController.delete_success", comment: "")
            //Show Operation Info
            operationInfoHeightConstraint.constant = 50
            initializeTableView()
            initializeDataSource()
            //callLocalURL()
            //setUpUI()
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(DocumentsViewController.hideOperationView), userInfo: nil, repeats: false)
        } else if mode == Mode.edit {
            operationImageView.image = UIImage(named: "icon-success")
            operationLabel.text = NSLocalizedString("DocumentsViewController.modify_success", comment: "")
            //Show Operation Info
            operationInfoHeightConstraint.constant = 50
            
            initializeTableView()
            initializeDataSource()
            setUpUI()
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(DocumentsViewController.hideOperationView), userInfo: nil, repeats: false)
        }
    }
    
    
    func callWSReceipt(_ URLPosition:String, actualURL:String, actualURLName:String, idDomain: String, idRhEmp: String){
        print ("pasada Documentos ")
        print ("")
        print (actualURL)
        print (actualURLName)
        print (idDomain)
        print (idRhEmp)
        let dateFormatterDeny       = DateFormatter()
        let session                 = URLSession.shared
        self.multilateralIdArray    = []
        var arrayAuxiliarCounter    = 0
        
        var path            = actualURL+"/WS_Rest_HRV/rest/receipt/get"
        var result          = 1
        var emptyParameter  = ""
        var iniDate         = "Aug 3, 1999 3:47:15 PM"
        var endDate         = "Dec 3, 2025 3:47:15 PM"
        var statusReceipt   = "PENDIENTES_POR_FIRMAR_EMPLEADO"
        
        let JSONObject  =  "{\"idDomain\":\(idDomain),\"idRhEmp\":\"\(idRhEmp)\",\"statusReceipt\":\"\(statusReceipt)\",\"iniDate\":\"\(iniDate)\",\"endDate\":\"\(endDate)\",\"userDomain\":\"\",\"passwordDomain\":\"\",\"resultado\":\(1)}"
        
        
        let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = JSONObject.data(using: String.Encoding.utf8)
        
        let task2 = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                    
                    if (json["resultado"]as? Int != 0){
                        
                        var document = ""
                        
                        if var documentsArray = json["lstReceipts"] as? [[String: AnyObject]] {
                            for document in documentsArray{
                                var docType     = document["docType"] as! String
                                var iniDate     = document["iniDate"]
                                var endDate     = document["endDate"]
                                var fileName    = document["fileName"] as! String
                                var signDate    = document["signDate"]
                                var multilateralId = document["multilateralId"] as! Int
                                //swift
                                dateFormatterDeny.locale = Locale(identifier: "en_US")
                                dateFormatterDeny.dateFormat = "MMM d, yyyy HH:mm:ss a"
                                
                                var dateGet = dateFormatterDeny.date(from: iniDate as! String)
                                var dateGetEnd = dateFormatterDeny.date(from: endDate as! String)
                                
                                dateFormatterDeny.dateFormat = "dd/MM/YYYY"
                                //swift
                                iniDate = dateFormatterDeny.string(from: dateGet!) as AnyObject?
                                endDate = dateFormatterDeny.string(from: dateGetEnd!) as AnyObject?
                                
                                self.multilateralIdArray.append(Document(name: fileName , dateIni: iniDate as! String, dateEnd: endDate as! String, url: actualURLName,location: "xxxx", obs: "xxxholi", multilateralId: multilateralId, state: .collapsed))
                                
                                self.dict[actualURL] = self.multilateralIdArray
                                arrayAuxiliarCounter += 1
                            }
                            print ("Multilateral Array")
                            print (self.multilateralIdArray)
                            print ("Dictionary")
                            print (self.dict)
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
            self.initializeDataSource2()
        })
        
        task2.resume()
        
    }
    
    func callLocalURL(){
        // MBN: We are using the table for executing different actions, to reduce code I'm using the reloading data function
        dataSource = []
        
        var position        = 0
        var nameFromArray   = ""
        var urlFromArray    = ""
        var listaURL        = ""
        var listaURLNames   = ""
        var fullURLArr      = [String]()
        var fullNameArr     = [String]()
        
        //MBN: I'm saving the first URL typed on SetURLConfiguration View on userDefaults as "URLAccess" key, so if the "URL" key is empty means that user has only one URL stored and needs to being showed
        if (UserDefaults.standard.object(forKey: "URL") == nil){
            print ("Entre a URL nill, no existe una lista de URLS")
            listaURL        = UserDefaults.standard.object(forKey: "URLAccess") as! String
            fullURLArr.append(listaURL)
            listaURL        = listaURL + ","
            
            listaURLNames   = UserDefaults.standard.object(forKey: "URLNameAccess") as! String
            fullNameArr.append(listaURLNames)
            listaURLNames   = listaURLNames + ","
        }
            //MBN: If the "URL" key isn't empty means that user has more URL Strings and is not the initial one
        else{
            listaURL        = UserDefaults.standard.object(forKey: "URL") as! String
            listaURLNames   = UserDefaults.standard.object(forKey: "URLName") as! String
            
            var lastChar    = listaURL.characters.last!
            var lastChar2   = listaURLNames.characters.last!
            
            //MBN: Veryfy if lastChar contains a character that you want to remove, in this case I chose "," because it's the way I concatenate stored URL (userDefaults only save strings or integers)
            if (lastChar == ","){
                //MBN: Update the string, by getting the last character and replacing it.
                listaURL = (listaURL as NSString).replacingCharacters(in: NSRange(location: listaURL.characters.count - 1, length: 1), with: "")
            }
            //MBN: Same as above
            if (lastChar2 == ","){
                listaURLNames = (listaURLNames as NSString).replacingCharacters(in: NSRange(location: listaURLNames.characters.count - 1, length: 1), with: "")
            }
            
            fullURLArr = listaURL.components(separatedBy: ",")
            fullNameArr = listaURLNames.components(separatedBy: ",")
        }
        print ("lista de URL dadas de alta")
        print (listaURL)
        print ("lista de URL Names")
        print (listaURLNames)
        
        
        // MBN: Counting how many elements are into the array, this will make you understand better the way I'm saving URL strings
        position        = 0
        print (fullNameArr)
        print (fullNameArr.count)
        print (fullURLArr)
        print (fullURLArr.count)
        
        var extensiones = fullURLArr.count
        
        // MBN:For every URL on Array, insert a Row on TableView
        for urlFromArray in fullURLArr {
            print("URL from Array CallLocalURL")
            nameFromArray = fullNameArr[position]
            // MBN: "Childs" are the documents saved on URL, I'm not adding anything yet
            print(nameFromArray)
            if var childsArray = self.dict[urlFromArray] {
                // now val is not nil and the Optional has been unwrapped, so use it
                print("entre")
                print("*****************************************")
                print("posicion del key")
                print(urlFromArray)
                print("*****************************************")
                var URLRowClassification = URL(state: .collapsed, childs: childsArray, name: nameFromArray, url: urlFromArray)
                dataSource.append(URLRowClassification)
            }
            else{
                var URLRowClassification = URL(state: .collapsed, childs:[], name: nameFromArray, url: urlFromArray)
                dataSource.append(URLRowClassification)
                
            }
            // MBN: This are the elements inside the tableview row inserted above
            
            if (position < extensiones){
                position = position + 1
            }
        }
        DispatchQueue.main.async{
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
        
        total = fullNameArr.count
    }
    
    func getURLInfoArray(_ URLPosition:Int) -> Array<String> {
        
        let URLList         = UserDefaults.standard.object(forKey: "URL") as! String
        
        let idRhEmpList     = UserDefaults.standard.object(forKey: "URLIdRhList") as! String
        
        let idDomainList    = UserDefaults.standard.object(forKey: "URLIdDomainList") as! String
        
        let URLNamesList    = UserDefaults.standard.object(forKey: "URLName") as! String
        
        //var URLInfoArray    = []
        print("lista de arreglos")
        print(":::::::::::::::::::::::::::::::::::")
        print("Lista de URLS")
        print(URLList)
        print("Lista de idsRh")
        print(idRhEmpList)
        print("Lista de Dominios")
        print(idDomainList)
        print("Lista de nombres de URL")
        print(URLNamesList)
        print(":::::::::::::::::::::::::::::::::::")
        
        let URLKeysList         = UserDefaults.standard.object(forKey: "assignedKeysList") as! String
        
        let URL         = URLList.components(separatedBy: ",")
        let idRhEmp     = idRhEmpList.components(separatedBy: ",")
        let idDomain    = idDomainList.components(separatedBy: ",")
        let URLName     = URLNamesList.components(separatedBy: ",")
        let URLKeys     = URLKeysList.components(separatedBy: ",")
        
        var URLArray    = [String]()
        print("urls separadas")
        print(URL)
        print("aqui se generará el error")
        print(URLPosition)
        URLArray.append(URL[URLPosition])
        URLArray.append(idRhEmp[URLPosition])
        URLArray.append(idDomain[URLPosition])
        URLArray.append(URLName[URLPosition])
        URLArray.append(URLKeys[URLPosition])
        
        return URLArray
    }
    
    func CallWSCancelDocument(){
        
        var reasonForCancelation        = UserDefaults.standard.object(forKey: "temporalReasonForCancelation") as! String
        
        var multilateralId              = UserDefaults.standard.object(forKey: "temporalMultilateralIdAction") as! Int
        
        var URLPosition                 = UserDefaults.standard.object(forKey: "SelectedURL") as! Int
        
        var URLInformationArray         = getURLInfoArray(URLPosition)
        
        var cancelReceipt               = false
        
        let emptyParameter              = "\"\""
        
        let resultado                   = 1
        
        if (URLInformationArray[0] != ""){
            cancelReceipt  = true
            let path       = URLInformationArray[0]+"/WS_Rest_HRV/rest/receipt/cancel"
            
            let JSONObject = "{\"idDomain\":\(URLInformationArray[2]),\"idRhEmp\":\"\(URLInformationArray[1])\",\"userDomain\":\(emptyParameter),\"passwordDomain\":\(emptyParameter),\"multilateralId\":\(multilateralId),\"cancelReceipt\":\(cancelReceipt),\"reasonForCancellation\":\"\(reasonForCancelation)\",\"resultado\":\(resultado)}"
            print("parametros cancelacion")
            //print(JSONObject)
            
            print ("Razon de cancelación")
            print (reasonForCancelation.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            print("cadena sin utf8")
            print(JSONObject)
            print("cadena con utf8")
            
            
            let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = JSONObject.data(using: String.Encoding.utf8)
            print("requestHTTPBody")
            print(request.httpBody)
            let task = self.session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard data != nil else {
                    print("no data found: \(error)")
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                        if (json["resultado"]as? Int != 0){
                            print ("el documento ha sido cancelado satisfactoriamente")
                            //self.showAlertMessage("DocumentsViewController.cancelDocumentSuccess")
                            var response = self.getURLInfoArray(URLPosition)
                            //self.callWSReceipt(String(URLPosition), actualURL: response[0], actualURLName:response[3], idDomain: response[2], idRhEmp: response[1])
                            //self.initializeDataSource2()
                            //self.callLocalURL()
                            UserDefaults.standard.set(nil , forKey: "URLPosition")
                            UserDefaults.standard.synchronize()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "prepareDocumentsBeforeSet"), object: nil)
                            //self.showAlertMessage("DocumentsViewController.cancelDocumentSuccess")
                        }
                        else{
                            print("Response: \(json)")
                            print ("No se pudo cancelar el documento")
                            self.showAlertMessage("DocumentsViewController.cancelDocumentFailed")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "prepareDocumentsBeforeSet"), object: nil )
                            
                        }
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
                    self.showAlertMessage("misc.notResponseFromServer")
                }
                //TODO
                UserDefaults.standard.set(nil, forKey: "URLPosition")
                UserDefaults.standard.synchronize()
                
            })
            task.resume()
        }
    }
    
    func CallWSGetHash(){
        print("llegue a get hash")
        var assignedKeysList                = UserDefaults.standard.object(forKey: "assignedKeysList") as! String
        print("Obteniendo la posicion de URL seleccionada")
        
        var selectedURL                 = UserDefaults.standard.object(forKey: "SelectedURL") as! Int
        print("1.2 selectedURL:")
        print(selectedURL)
        
        var position    = assignedKeysList.components(separatedBy: ",")
        var URLPosition = position[selectedURL]
        
        if (URLPosition != "-1"){
            //var multilateralId              = UserDefaults.standard.object(forKey: "temporalMultilateralIdAction") as! Int
            var multilateralId = UserDefaults.standard.object(forKey: "temporalMultilateralId") as! Int
            print("paso 2")
            
            var URLInformationArray         = getURLInfoArray(selectedURL)
            print("paso 4")
            var resultado                   = 1
            print("paso 5")
            let path                        = URLInformationArray[0]+"/WS_Rest_HRV/rest/employee/gethash"
            print("paso 6")
            var b64Required = "1"
            print(" hash Function: 2.1")
            //15/11/16
            var certificatesList = UserDefaults.standard.object(forKey: "CerB64List") as! String
            print("10")
            // print(certificate)
            var privateKeysList  = UserDefaults.standard.object(forKey: "KeyB64List") as! String
            print("11")
            // print (privateKey)
            var password    = UserDefaults.standard.object(forKey: "userIdentifierFirmApp") as! String
            print("12")
            print(password)
            print("12.1")
            var certificatesArray   = certificatesList.components(separatedBy: ",")
            print("12.2")
            print(certificatesArray)
            var keysArray           = privateKeysList.components(separatedBy: ",")
            print("12.3")
            var certificate         = certificatesArray[Int(URLPosition)!]
            print("12.4")
            var privateKey          = keysArray[Int(URLPosition)!]
            print("12.5")
            print ("certificado")
            print (certificate)

            print ("llave privada")
            print (privateKey)
            
            let JSONObject  = "{\"idDomain\":\(URLInformationArray[2]),\"idRhEmp\":\"\(URLInformationArray[1])\",\"multilateralId\":\(multilateralId),\"resultado\":\(resultado)}"
            print (JSONObject)

            let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = JSONObject.data(using: String.Encoding.utf8)

            let task = self.session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard data != nil else {
                    print("no data found: \(String(describing: error))")
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                        
                        if (json["resultado"] as? Int != 0){
                            print ("el documento ha sido obtenido")
                            
                            // Libreria
                            let functionTest2 = SgLib()
                            
                            // Obtenemos
                            
                            let hashHex = json["hashHex"] as! String
                            let multilateralId = json["multilateralId"] as! Int
                            
                            // Alerta
                            let alertView = UIAlertController(title: "Regresa Hexa", message: "hashHex: \(hashHex)\nmultilateralId: \(multilateralId)", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                
                            })
                            alertView.addAction(action)
                            self.present(alertView, animated: true, completion: nil)
                            
                            print("hashHex: \(hashHex)")
                            print("multilateralId: \(multilateralId)")
                            
                            // Solicitamos Pkcs7
                            
                            /*
                             var hash = "PKz+Paap6wWm0i8OsSkkHnD2KHrj6Wwk9d1F38Z6CtA="
                             func genPkcs7FromHashSwift(_ certificate : String,
                             privateKey : String,
                             password : String,
                             hash : String,
                             b64Required : UInt8) -> (Int32, Data)
                             */
                            
                            
                            let i:UInt8 = 1
                            
                            let responsed = functionTest2.genPkcs7FromHashSwift(certificate,
                                                                                privateKey: privateKey,
                                                                                password: password,
                                                                                hash:hashHex,
                                                                                b64Required: i)
                            
                            
                            // Alerta
                            let alertView2 = UIAlertController(title: "genPkcs7FromHashSwift", message: "Int: \(responsed.0)\nData: \(responsed.1.description)", preferredStyle: .alert)
                            let action2 = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            })
                            alertView2.addAction(action2)
                            self.present(alertView2, animated: true, completion: nil)
                            
                            
                            // Obtenemos Pkcs7 de la Dupla (1000, pkcs7)
                            // ahora la Tupla es: (Int32, Data)
                            let strPkcs7 = responsed.0 // Ahora solo un Int32
                            let pkcs7Data = responsed.1 // Ahora contiene un Data
                            let b64Pkcs7 = pkcs7Data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                            print(b64Pkcs7)
                            
                            // Alerta
                            let alertView3 = UIAlertController(title: "base64EncodedString", message: "b64Pkcs7: \(b64Pkcs7)\n", preferredStyle: .alert)
                            let action3 = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            })
                            alertView3.addAction(action3)
                            self.present(alertView3, animated: true, completion: nil)
                            
                            self.CallWSEstablishDocument(b64Pkcs7, url: URLInformationArray[0], idDomain: URLInformationArray[2], idRhEmp: URLInformationArray[1], multilateralId: multilateralId)
                            
                            UserDefaults.standard.set(nil, forKey: "Action")
                            UserDefaults.standard.set(nil, forKey: "temporalMultilateralId")
                            UserDefaults.standard.synchronize()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "prepareDocumentsBeforeSet"), object: nil )
                        }
                        else{
                            print("Response: \(json)")
                            print ("No se pudo obtener hash de documento")
                            self.showAlertMessage("DocumentsViewController.signingDocumentFailed")
                        }
                    }
                    else {
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }
                catch let parseError {
                    print(parseError)
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: '\(jsonStr)'")
                    self.showAlertMessage("misc.notResponseFromServer")
                }
            })
            task.resume()
        }
        else{
            showAlertMessage("DocumentsViewController.notKeysSetted")
        }
    }
    
    func CallWSEstablishDocument(_ b64Pkcs7:String, url :String, idDomain:String, idRhEmp:String, multilateralId:Int){
        print("CallWSEstablishDocument")
        var bISendEmail                 = false
        var emptyParameter              = "\"\""
        var resultado                   = 1

        if (url != ""){

            let path        = url+"/WS_Rest_HRV/rest/employee/establish"
            
            let JSONObject  = "{\"idDomain\":\(idDomain),\"idRhEmp\":\"\(idRhEmp)\",\"multilateralId\":\(multilateralId),\"b64Pkcs7\":\"\(b64Pkcs7)\",\"userDomain\":\(emptyParameter),\"passwordDomain\":\(emptyParameter),\"blSendEmail\":\(bISendEmail),\"emailToSend\":\(emptyParameter),\"resultado\":\(resultado)}"
            print (JSONObject)
            
            
            // Alerta
            let alertView4 = UIAlertController(title: "CallWSEstablishDocument", message: "Url: \(path)\nJson:\(JSONObject)", preferredStyle: .alert)
            let action4 = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            })
            alertView4.addAction(action4)
            self.present(alertView4, animated: true, completion: nil)
            
            
            let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = JSONObject.data(using: String.Encoding.utf8)
            
            let task = self.session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard data != nil else {
                    print("no data found: \(error)")
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                        print(json as AnyObject)
                        if (json["resultado"] as? Int != 0){
                            print ("el documento ha sido firmado satisfactoriamente")
                            self.showAlertMessage("DocumentsViewController.signingDocumentSuccess")
                        }
                        else{
                            print("Response: \(json)")
                            print ("No se pudo firmar el documento")
                            self.showAlertMessage("DocumentsViewController.signingDocumentFailed")
                        }
                    }
                    else {
                        
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }
                catch let parseError {
                    print(parseError)
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: '\(jsonStr)'")
                    self.showAlertMessage("misc.notResponseFromServer")
                }
            })
            task.resume()
        }
    }
    
    func CallWSGetDocument(){
        var path    = ""
        var JSONObject  = ""
        print ("CallWSGetDocument 2")
        UserDefaults.standard.removeObject(forKey: "multilateralIdBase64Document")
        UserDefaults.standard.synchronize()
        
        if ( UserDefaults.standard.object(forKey: "PDFCall") != nil)
        {

            var multilateralId  = UserDefaults.standard.integer(forKey: "temporalMultilateralId")
            
            var URLPosition     = UserDefaults.standard.integer(forKey: "SelectedURL")
            var emptyParameter  = "\"\""
            
            var resultado       = 1
            
            var response        = getURLInfoArray(URLPosition)
            
            path        = response[0]+"/WS_Rest_HRV/rest/document/get"

            JSONObject  = "{\"idDomain\":\(response[2]),\"idRhEmp\":\"\(response[1])\",\"multilateralId\":\(multilateralId),\"userDomain\":\(emptyParameter),\"passwordDomain\":\(emptyParameter),\"resultado\":\(resultado)}"
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print(JSONObject)
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            
        }
        
        if (UserDefaults.standard.object(forKey: "PDFCall") == nil){

            var multilateralId  = UserDefaults.standard.integer(forKey: "temporalMultilateralId")
            
            var URLPosition     = UserDefaults.standard.object(forKey: "URLSelected") as! String
            
            var emptyParameter  = "\"\""
            
            var resultado       = 1
            
            var response        = getURLInfoArray(Int(URLPosition)!)
            
            path        = response[0]+"/WS_Rest_HRV/rest/document/get"

            
            JSONObject  = "{\"idDomain\":\(response[2]),\"idRhEmp\":\"\(response[1])\",\"multilateralId\":\((multilateralId)),\"userDomain\":\(emptyParameter),\"passwordDomain\":\(emptyParameter),\"resultado\":\(resultado)}"
            
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print(JSONObject)
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
        }

        
        let request = NSMutableURLRequest(url: Foundation.URL(string:path)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = JSONObject.data(using: String.Encoding.utf8)
        
        let task = self.session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                    if (json["resultado"]as? Int != 0){
                        print ("se obtuvo el b64 del documento exitosamente")
                        print (json["base64document"] as! String)
                        
                        var base64String = json["base64document"] as! String
                        
                        
                        UserDefaults.standard.set(base64String, forKey: "multilateralIdBase64Document")
                        UserDefaults.standard.synchronize()
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "RedrawFile"), object: nil )
                        
                        
                        UserDefaults.standard.set(nil, forKey: "Action")
                        UserDefaults.standard.set(nil, forKey: "temporalMultilateralId")
                        UserDefaults.standard.synchronize()
                        
                    }
                    else{
                        print("Response: \(json)")
                        print ("No se obtuvo el b64 del documento")
                        self.showAlertMessage("misc.notResponseFromServer")
                    }
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
                self.showAlertMessage("misc.notResponseFromServer")
            }
        })
        task.resume()
        
    }
    
}
