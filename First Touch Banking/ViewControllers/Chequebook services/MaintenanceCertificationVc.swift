//
//  MaintenanceCertificationVc.swift
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
var  dateString  : String?
class MaintenanceCertificationVc: BaseVC {
    private var pdfFile: String?
    var userCnic : String?
    var AccountNo : String?
    var AccountTitle : String?
    var Branchname : String?
    var OpeningDate: String?
    var BranchCode : String?
    var UserCnic : String?
    var myarr : [MinteneceOpeningdateData] = []
    var maintenceCerObj : MaintenanceCertificate?
    
    
    @IBOutlet weak var btnsave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnsave.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 175
        
        lblMian.text = "Accounts Maintenance Certificate".addLocalizableString(languageCode: languageCode)
        btnsave.setTitle("SAVE".addLocalizableString(languageCode: languageCode), for: .normal)
        MaintenaceCertification()
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        dateString = df.string(from: date)
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblMian: UILabel!
    
    @IBAction override func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
        
    @IBAction func save(_ sender: UIButton) {
        let tag = sender.tag
        //        NSLog ("You selected row: %@ \(tag)")
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MaintenanceCertificateVC") as! MaintenanceCertificateVC
        vc.documentData = createPDF()
        vc.AccountNo = maintenceCerObj?.MCdata?[tag].vAccount
        vc.AccountTitle = maintenceCerObj?.MCdata?[tag].vTitleofAccount
        vc.Branchname = maintenceCerObj?.MCdata?[tag].vBranchName
        vc.OpeningDate = maintenceCerObj?.MCdata?[tag].vAccountOpeningDate
        vc.BranchCode = maintenceCerObj?.MCdata?[tag].vBranchCode
        vc.UserCnic = maintenceCerObj?.MCdata?[tag].vCNICNo
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    private func MaintenaceCertification(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/RequestMaintenanceCertificate"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<MaintenanceCertificate>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MaintenanceCertificate>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.maintenceCerObj = Mapper<MaintenanceCertificate>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    
                    if self.maintenceCerObj?.response == 2 || self.maintenceCerObj?.response == 1 {
                        
                        self.tableview.reloadData()
                        self.btnsave.isHidden = false
                        //                    if let message = self.maintenceCerObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
                    }
                    else {
                        if let message = self.maintenceCerObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.maintenceCerObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
class MinteneceOpeningdateData
{
    var vAccountOpeningDate  = ""
    
}

extension MaintenanceCertificationVc : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = maintenceCerObj?.MCdata?.count{
            return count
        }
        return 0
    }
    func loadtrasanctionbill()
    {
        var tempobj = MinteneceOpeningdateData()
        
        tempobj.vAccountOpeningDate = (maintenceCerObj?.MCdata?[0].vAccountOpeningDate) as! String
        
        myarr.append(tempobj)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MaintenaceCellVC") as! MaintenaceCellVC
        let aStatement = maintenceCerObj?.MCdata?[indexPath.row]
        aCell.lblAccTitleValue.text = aStatement?.vTitleofAccount
        aCell.lblAccNovalue.text = aStatement?.vCNICNo
        let tag = indexPath.row
        let splitdate = maintenceCerObj?.MCdata?[0].vAccountOpeningDate?.components(separatedBy: .whitespaces)
        print(splitdate!)
        
        aCell.lblOpeningDateValue.text =  "\(splitdate![0])"
        //        aCell.lblOpeningDateValue.text = aStatement?.vAccountOpeningDate
        aCell.lblBranchNameValue.text = aStatement?.vBranchName
        aCell.dropShadow1()
        aCell.lblStatusValue.text = aStatement?.vAccountStatus
        aCell.selectionStyle = .none
        
        AccountNo = maintenceCerObj?.MCdata?[indexPath.row].vAccount
        AccountTitle = maintenceCerObj?.MCdata?[indexPath.row].vTitleofAccount
        Branchname = maintenceCerObj?.MCdata?[indexPath.row].vBranchName
        OpeningDate = maintenceCerObj?.MCdata?[indexPath.row].vAccountOpeningDate
        BranchCode = maintenceCerObj?.MCdata?[indexPath.row].vBranchCode
        UserCnic = maintenceCerObj?.MCdata?[indexPath.row].vCNICNo
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
        //        NSLog ("You selected row: %@ \(indexPath)")
        //        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MaintenanceCertificateVC") as! MaintenanceCertificateVC
        //        vc.documentData = createPDF()
        //        vc.AccountNo = maintenceCerObj?.MCdata?[indexPath.row].vAccount
        //        vc.AccountTitle = maintenceCerObj?.MCdata?[indexPath.row].vTitleofAccount
        //        vc.Branchname = maintenceCerObj?.MCdata?[indexPath.row].vBranchName
        //        vc.OpeningDate = maintenceCerObj?.MCdata?[indexPath.row].vAccountOpeningDate
        //        vc.BranchCode = maintenceCerObj?.MCdata?[indexPath.row].vBranchCode
        //        vc.UserCnic = maintenceCerObj?.MCdata?[indexPath.row].vCNICNo
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
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
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;">ACCOUNT MAINTENANCE CERTIFICATE&nbsp;</span></u></strong></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;"><span style="text-decoration: none;">&nbsp;</span></span></u></strong></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
         <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-size:15px;font-family: Calibri, sans-serif;">This is to certify that&nbsp;</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> \(DataManager.instance.accountTitle ?? "") &nbsp; &nbsp;</span></strong><span style="font-size:13px;font-family: Calibri, sans-serif;">having <strong>CNIC # \(UserCnic ?? "") </strong>&nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">is maintaining &nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">account &nbsp;A/C#</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> \(AccountNo! ?? "")&nbsp;</span></strong><span style="font-size:15px;font-family: Calibri, sans-serif;">with our <strong>\(Branchname! ?? "")-\(BranchCode! ?? "")</strong></span><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;from <strong>\(OpeningDate! ?? "")</strong></span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">This certificate is issued on request of the customer without taking any risk and responsibility&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">on undersigned and part of the bank.</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">The HBL MicroFinance Bank Ltd</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">16<sup>th</sup> &amp; 17<sup>th</sup> Floor HBL Tower,</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Blue Area, Islamabad</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Toll Free 0800-34778 or 0800-42563</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
        <p style='margin: 0cm;font-family: "Times New Roman", serif;'><em><span style="font-family: Calibri, sans-serif;">This is a computer generated certificate &amp; don&rsquo;t require any signatures</span></em></p>
        
        
        
        
                
        """
        
    }
}

