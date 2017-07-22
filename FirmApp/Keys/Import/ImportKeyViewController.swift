import UIKit
import Foundation
//import ImportKeyViewController

class ImportKeyViewController: UIViewController, UIDocumentPickerDelegate{
 
    @IBOutlet weak var openWithLabel: UILabel!
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    @IBOutlet weak var iCloudButton: UIButton!
    @IBOutlet weak var iTunesButton: UIButton!

    var alertMessage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("llegue")
        setUpUI()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: Foundation.URL) {
        print("Document Picker delegate recognized ")
        var fileName:String = url.lastPathComponent
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
                    // Read the file contents
                     let hexString = try Data(contentsOf: url)
                     print("File Text: \(hexString)")
                     
                     var strBase64:String = hexString.base64EncodedString(options: .lineLength64Characters)
                     print ("Encoded:" + strBase64)
                     strBase64 = hexString.base64EncodedString(options: .endLineWithLineFeed)
                     print ("Cleaned:" + strBase64)
                     UserDefaults.standard.set(strBase64, forKey: "temporalFile")
                    //var fileNameArray = fileName.componentsSeparatedByString(".")
                    
                    if ((fileExtension[1] != "cer") && (fileExtension[1] != "key")) {
                        self.alertMessage = "ImportKeyViewController.fileValidation"
                        self.showAlertMessage(alertMessage: self.alertMessage)
                    }
                    else{
                        var hexString: String = UserDefaults.standard.object(forKey: "temporalFile") as! String
                        if (fileExtension[1]=="cer")
                        {
                            UserDefaults.standard.set(fileName, forKey: "temporalCerFile")
                            UserDefaults.standard.set(hexString, forKey: "temporalCer64")
                        }
                        else{
                            UserDefaults.standard.set(fileName, forKey: "temporalKeyFile")
                            UserDefaults.standard.set(hexString, forKey: "temporalKey64")
                        }
                        UserDefaults.standard.synchronize()
                    }
                    //hasta aqui
                }
                catch let error as NSError {
                    print("Failed reading from URL: \(fileExtension), Error: " + error.localizedDescription)
                }
            }
        }

        //var archivo = url
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancelled")
        
    }
    func setUpUI() {
        openWithLabel.font = AppConstants.Font.OPEN_SANS_POP_UP_TITLE
        openWithLabel.textColor = UIColor(hexString: AppConstants.Color.TEXT_PRIMARY)
        openWithLabel.text = NSLocalizedString("ImportKeyViewController.open", comment: "")
        
        iCloudButton.setTitle(NSLocalizedString("ImportKeyViewController.icloud", comment: "").uppercased(), for: UIControlState())
        Utils.setColor(UIColor.white, forState: UIControlState(), button: iCloudButton)
        iCloudButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        iCloudButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
        
        iTunesButton.setTitle(NSLocalizedString("ImportKeyViewController.itunes", comment: "").uppercased(), for: UIControlState())
        Utils.setColor(UIColor.white, forState: UIControlState(), button: iTunesButton)
        iTunesButton.setTitleColor(UIColor(hexString: AppConstants.Color.TEXT_PRIMARY), for: UIControlState())
        iTunesButton.titleLabel?.font = AppConstants.Font.OPEN_SANS_BUTTON
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
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController (documentTypes: ["public.text","public.content"], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated:true, completion: nil)
    }
    
    func showAlertMessage(alertMessage:String){
        let alertViewController = UIAlertController(title: NSLocalizedString("misc.error", comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: NSLocalizedString("misc.ok", comment: ""), style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
    }
    
}
