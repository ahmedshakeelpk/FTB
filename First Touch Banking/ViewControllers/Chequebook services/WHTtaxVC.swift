//
//  WHTtaxVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import WebKit
import SwiftKeychainWrapper
import ObjectMapper
class WHTtaxVC: BaseVC {
    var  dateString  : String?
    var userCnic : String?
    var customer_name : String?
    var ac_no : String?
    var fromNewDateVar : Date?
    var withoutholdingtax : Int?
    var dateFrom = NSDate()
    var dateTo = NSDate()
    var isFrom:String?
    var UserCnic : String?
    var whtTaxObj : WHTCalculations?
    
    
    @IBOutlet weak var btnsave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        btnsave.isHidden = true
        tableview.rowHeight = 200
        lblmain.text = "WHT Calculations".addLocalizableString(languageCode: languageCode)
        btnShow.setTitle("SHOW".addLocalizableString(languageCode: languageCode), for: .normal)
        btnsave.setTitle("SAVE".addLocalizableString(languageCode: languageCode), for: .normal)
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        dateString = df.string(from: date)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var Todatetextfield: UITextField!
    @IBOutlet weak var fromdateTextField: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnShow: UIButton!
    @IBAction func Show(_ sender: UIButton) {
        if self.fromdateTextField .text?.count == 0 {
         
            self.showToast(title: "Please select From Date")
            return
        }
        if self.Todatetextfield.text?.count == 0 {
            self.showToast(title: "Please select To Date")
            return
        }
           
        self.MaintenaceCertification()
    }
    
    @IBAction override func backPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Utility Methods
    
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
    
//    WHT CERtication
    func createPDF() -> Data {
        let html = getHTML()
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height:550.0) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
       
        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        return pdfData as Data
    }
    func getcnic()
    {
      
    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
    }
    else{
        userCnic = ""
    }
//        <img src="app_logo-1" width="32" height="32">
        
}
//    End
//    html
    func getHTML() -> String {
        return """
            <p style='margin: 0cm 0cm 0cm 72pt;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-size:24px;line-height: 36px;font-family: Arial, sans-serif;">
                   <img src= "app_logo-1.png"
                        width="30"
                        height="30" />
                           The HBL MicroFinance Bank Ltd</span></p>
            <div style="border-style: none none solid;border-bottom-width: 1pt;border-bottom-color: windowtext;padding: 0cm 0cm 1pt;">
                               <p style='margin: 0cm;font-size:16px;font-family: "Times New Roman", serif;border: none;padding: 0cm;'>&nbsp; &nbsp;&nbsp;</p>
             </div>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Date: \(dateString! ?? "")</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>&nbsp;</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>&nbsp;</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>From: \(Todatetextfield.text!)To: \(fromdateTextField.text!)&nbsp;</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>&nbsp;</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>Account Number : \(ac_no! ?? "")</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>Account Title:\(DataManager.instance.accountTitle ?? "")</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>CNIC: \(userCnic! ?? "")</p>
            
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: center;line-height: 24px;'><strong>&nbsp;</strong></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: center;line-height: 24px;'><strong>Tax Certificate</strong></p>
                                             
            
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>This is to certify that With Holding Tax amounting to Rs. 3.90 (Three and paise Ninety) has been deducted from above mentioned account as per Income Tax Ordinance and the same has been deposited in the Government Treasury.</p>
                
            <p>Disclaimer: This is computer generated Withholding Tax (WHT) Certificate issued on customer request and does not require signature. HBL MFB shall  not be liable for any act or omission on the part of Bank, its officers, agents, representatives, or employees. Please verify the details and in case of any issue please contact your account maintaining branch.</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>&nbsp;</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'>&nbsp;</p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;"> HBL MicroFinance Bank Ltd</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">16<sup>th</sup> &amp; 17<sup>th</sup> Floor HBL Tower,</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Blue Area, Islamabad</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Toll Free 0800-34778 or 0800-42563</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><em><span style="font-family: Calibri, sans-serif;">This is a computer generated certificate &amp; don&rsquo;t require any signatures</span></em></p>
            
            
            """

        }
    
    
    
    
    
//    end
    private func MaintenaceCertification(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/whtCalculations"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        //        + " 00:00:01"
        //        + " 23:59:59"
        //        let parameters = ["from":convertDateFormater(Todatetextfield.text!) ,"to":convertDateFormater(fromdateTextField.text!)]
        //        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["from":convertDateFormater(fromdateTextField.text!) ,"to":convertDateFormater(Todatetextfield.text!)]
        //
        print(compelteUrl)
        //        print(parameters)
        print(params)
        print(DataManager.instance.stringHeader!)
        //
        //
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: JSONEncoding.default, headers:header).response { response in
            //        Object { (response: DataResponse<WHTCalculations>) in
            //
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding:JSONEncoding.default , headers:header).responseObject { (response: DataResponse<WHTCalculations>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.whtTaxObj = Mapper<WHTCalculations>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.whtTaxObj?.response == 2 || self.whtTaxObj?.response == 1 {
                        if self.whtTaxObj?.dataCalulations == nil{
                            self.showAlert(title: "", message: "Unable To Proceed Your Request", completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                        self.tableview.reloadData()
                        
                        if let message = self.whtTaxObj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                self.tableview.reloadData()
                                
                                //                        self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    else {
                        if let message = self.whtTaxObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
                else {
                    if let message = self.whtTaxObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        let tag = sender.tag
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "WHTCertificateVC") as! WHTCertificateVC
        vc.documentData = createPDF()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    }

extension WHTtaxVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = whtTaxObj?.dataCalulations?.count{
            return count
            self.btnsave.isHidden = false
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "WHTCellvc") as! WHTCellvc
        let tag = indexPath.row
        let aStatement = whtTaxObj?.dataCalulations?[indexPath.row]
        aCell.lblCnicValue.text = aStatement?.cnic
        aCell.customerNameValue.text = aStatement?.customer_name
        aCell.AccNoValue.text = aStatement?.ac_no
        aCell.dropShadow1()
        aCell.whtValue.text = "\(aStatement?.wht_cash)"
        aCell.WHTProfitValue.text = "\(aStatement?.wht_profit)"
        aCell.selectionStyle = .none
        customer_name = aStatement?.customer_name
        ac_no = aStatement?.ac_no

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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "WHTCertificateVC") as! WHTCertificateVC
        vc.documentData = createPDF()
        self.navigationController?.pushViewController(vc, animated: true)
    }




}
