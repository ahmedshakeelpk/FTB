//
//  E-StatmentVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import PDFKit
import ObjectMapper

class E_StatmentVC: BaseVC {
    
    public var documentData: Data?
    var fromNewDateVar : Date?
    var withoutholdingtax : Int?
    var dateFrom = NSDate()
    var dateTo = NSDate()
    var isFrom:String?
    var picker = UIImagePickerController()
    var eStatment : EStatment?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 100
        tableview.isHidden = true
        btnsave.isHidden = true
        //        pdfDataWithTableView(tableView: UITableView)
        lblmain.text = "E Statment".addLocalizableString(languageCode: languageCode)
        btnShow.setTitle("SHOW".addLocalizableString(languageCode: languageCode), for: .normal)
        btnsave.setTitle("SAVE".addLocalizableString(languageCode: languageCode), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var Todatetextfield: UITextField!
    @IBOutlet weak var fromdateTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnShow: UIButton!
    var pdfFilePath : AnyObject?
    
    func pdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        
        let fittedSize = tableView.sizeThatFits(CGSize(
            width: priorBounds.size.width,
            height: tableView.contentSize.height
        ))
        
        tableView.bounds = CGRect(
            x: 0, y: 0,
            width: fittedSize.width,
            height: fittedSize.height
        )
        
        let pdfPageBounds = CGRect(
            x :0, y: 0,
            width: tableView.frame.width,
            height: self.view.frame.height
        )
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
            tableView.contentOffset = CGPoint(x: 0, y: pageOriginY) // move "renderer"
        }
        UIGraphicsEndPDFContext()
        
        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        pdfData.write(to: docURL as URL, atomically: true)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("studentRecord").appendingPathExtension("pdf")
        else { fatalError("Destination URL not created") }
        
        pdfData.write(toFile: "\(documentsPath)/studentRecord.pdf", atomically: true)
        //                loadPDF(filename: "studentRecord.pdf")
        savePdf(urlString: "\(docURL)", fileName: "myDocument.pdf")
        
    }
    //
    
    
    @IBAction func save(_ sender: UIButton) {
        
        pdfDataWithTableView(tableView: self.tableview)
        
    }
    func savePdf(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            self.sharePdf(path: url!)
            //
        }
    }
    func sharePdf(path:URL) {
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path.path) {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("document was not found")
            let alertController = UIAlertController(title: "Error", message: "Document was not found!", preferredStyle: .alert)
            let defaultAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        //     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // MMM d, yyyy
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if isFrom == "dateFrom"{
            fromdateTextField.text = dateFormatter.string(from: sender.date)
            dateFrom =  sender.date as NSDate
            self.fromNewDateVar = sender.date
        }
        else if isFrom == "dateTo"{
            Todatetextfield.text = dateFormatter.string(from: sender.date)
            dateTo = sender.date as NSDate
        }
    }
    @IBAction func textfieldFromDate(_ sender: UITextField) {
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        fromdateTextField.inputView = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        isFrom = "dateFrom"
        datePickerObj.maximumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromNewDate = dateFormatter.string(from: datePickerObj.date)
        self.fromNewDateVar = datePickerObj.date
        self.fromdateTextField.text = fromNewDate
        //        if #available(ios 13.4, *)
        //        {
        //            if #available(iOS 13.4, *) {
        //                datePickerObj.preferredDatePickerStyle = .wheels
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        }
        if #available(iOS 13.4, *) {
            datePickerObj.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerObj.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerObj.preferredDatePickerStyle = .wheels
            datePickerObj.preferredDatePickerStyle = .wheels
        }
        self.Todatetextfield.isUserInteractionEnabled = true
    }
    
    
    @IBAction func toDate(_ sender: UITextField) {
        
        //    let currentDate = Date()
        
        let currentDate = self.fromNewDateVar
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let oneMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate!)
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        Todatetextfield.inputView = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        isFrom = "dateTo"
        
        //        datePickerObj.minimumDate = oneMonthAgo
        //        datePickerObj.maximumDate = currentDate
        
        datePickerObj.minimumDate = currentDate
        datePickerObj.maximumDate = oneMonthAgo
        
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.Todatetextfield.text = newDate
        //            if #available(ios 13.4, *)
        //            {
        //                if #available(iOS 13.4, *) {
        //                    datePickerObj.preferredDatePickerStyle = .wheels
        //                } else {
        //                    // Fallback on earlier versions
        //                }
        //            }
        if #available(iOS 13.4, *) {
            datePickerObj.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerObj.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerObj.preferredDatePickerStyle = .wheels
            datePickerObj.preferredDatePickerStyle = .wheels
        }
        
    }
    
    
    @IBAction func Show(_ sender: UIButton) {
        if self.fromdateTextField .text?.count == 0 {
            
            self.showToast(title: "Please select From Date")
            return
        }
        if self.Todatetextfield.text?.count == 0 {
            self.showToast(title: "Please select To Date")
            return
        }
        self.EStatment()
        
    }
    
    @IBAction  override func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    private func EStatment(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        //http://mobappuat.fmfb.pk/
        
        //       let compelteUrl =  "http://mobappuat.fmfb.pk/api/v1/Customers/EStatement"
        let compelteUrl =  Constants.BASE_URL + "api/v1/Customers/EStatement"
        //       "to_date": "2021-10-30", "from_date": "2021-01-24"
        let params = ["from_date": convertDateFormater(Todatetextfield.text!) ,"to_date":  convertDateFormater(fromdateTextField.text!)]
        
        //       ,"Host": "http://mobappuat.fmfb.pk/"
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        //       , "Host": "http://mobappuat.fmfb.pk/"
        print(header)
        print(params)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: JSONEncoding.default, headers:header).response { response in
            //           Object { (response: DataResponse<EStatment>) in
            
            //
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<EStatment>) in
            //
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.eStatment = Mapper<EStatment>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.eStatment?.response == 2 || self.eStatment?.response == 1 {
                        self.tableview.isHidden = false
                        self.btnsave.isHidden = false
                        self.tableview.reloadData()
                        //                if let message = self.eStatment?.message{
                        //                    self.showDefaultAlert(title: "", message:message)
                        //                }
                    }
                    else {
                        if let message = self.eStatment?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.eStatment?.message{
                        self.showDefaultAlert(title: "", message: message)
                        
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}


extension E_StatmentVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = eStatment?.data?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "EStatementCEllVc") as! EStatementCEllVc
        let aStatement = eStatment?.data?[indexPath.row]
        aCell.lblamounttag.text = aStatement?.amount_tag
        
        //        , \(aStatement?.drcr_ind!)"
        
        aCell.lbldateplusdrcrind.text = (aStatement?.txn_init_date!)
        aCell.lbllcyamount.text = aStatement?.lcy_amount
        aCell.dropShadow1()
        aCell.selectionStyle = .none
        return aCell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
    
    
    
    
    
}
//extension UITableView {
//
//    // Export pdf from UITableView and save pdf in drectory and return pdf file path
//    func exportAsPdfFromTable() -> String {
//
//        let originalBounds = self.bounds
//        self.bounds = CGRect(x:originalBounds.origin.x, y: originalBounds.origin.y, width: self.contentSize.width, height: self.contentSize.height)
//        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.contentSize.height)
//
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
//        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
//        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
//        self.layer.render(in: pdfContext)
//        UIGraphicsEndPDFContext()
//        self.bounds = originalBounds
//        // Save pdf data
//        return self.saveTablePdf(data: pdfData)
//
//    }
//
//    // Save pdf file in document directory
//    func saveTablePdf(data: NSMutableData) -> String {
//
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let docDirectoryPath = paths[0]
//        let pdfPath = docDirectoryPath.appendingPathComponent("tablePdf.pdf")
//        if data.write(to: pdfPath, atomically: true) {
//            return pdfPath.path
//        } else {
//            return ""
//        }
//    }
//}
