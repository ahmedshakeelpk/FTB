//
//  ScanReader_VC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 06/08/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import iOSDropDown
import Alamofire
//import AlamofireObjectMapper
import Nuke
import MobileCoreServices
import Photos
import OpalImagePicker
import MapKit
import ObjectMapper
class ScanReader_VC: BaseVC,UINavigationControllerDelegate {
    var Fetch_img : UIImage?
    var Ftech_String : String?
    
//    var Fetch_img = UIImage(named: "AppIcon-1.png")
//    for static
//    var Ftech_String  = "0002020102110202000424PK77UNIL010900023785421010049FBB"
//    for dynamic
//var Ftech_String  = "0002020102120202000424PK77UNIL010900023785421005045000071230062022145810042007"
    var GetPayloadformatindicatorId  : String?
    var PayLoadIDLength :String?
    var GEtPayloadformatindicatorvalue : String?
    var Pointofinitiationmethodid : String?
    var InitiationMethodLength :String?
    var GettPointofinitiationmethodstaticvalue :String?
    var GetSchemeidentifierid :String?
    var SchemeIdentifierLength : String?
    var GetSchemeidentifiervalue :String?
    var IGetBANid :String?
    var Iban_Length : String?
    var date_fromstring = ""
    var GetIBAN  :String?
    var Getamountid :String?
    var IBANCode  :String?
    var AmountCLenghtCount : String?
    var GetAmountValue: String?
    var Getexpirydateid :String?
    var ExpiryDate_Length : String?
    var Expiry_date: String?
    var GetCRCid :String?
    var CRD_Length : String?
    var GetCRCvalue :String?
    var Get_Stringfrom_QRSccaner : String?
    var Current_Date : String??
    var Transactionamount : Double?
    var getString : String?
    var reasonObj:GetReaons?
    var reasonsList = [SingleReason]()
    var arrReasonsList : [String]?
    var sourceReasonForTrans:String?
    var selectedlist : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy-HH-mm"
        Current_Date = df.string(from: date)
        print("current date is", Current_Date!)
        print("image is" ,Fetch_img)
        print("string is,",Ftech_String)
        Tableview1.isHidden = true
        getReasonsForTrans()
        methodDropDownInquiries()
        getString = Ftech_String
        breakString()
        imgview.image = Fetch_img
        lblMainTitle.text = "SCAN QR".addLocalizableString(languageCode: languageCode)
        btnprocess.setTitle("PROCESS".addLocalizableString(languageCode: languageCode), for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var lbl_ExpiryValue: UILabel!
    @IBOutlet weak var lbl_ExpiryDate: UILabel!
    @IBOutlet weak var lblIBAN: UILabel!
    @IBOutlet weak var lblQRCodetype: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var btnprocess: UIButton!
    @IBOutlet weak var schemetextfield: DropDown!
    @IBOutlet weak var purposetextfield: DropDown!
    @IBOutlet weak var amounttextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var lblValidation: UILabel!
    @IBOutlet weak var Tableview1: UITableView!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_Process(_ sender: UIButton) {
        if amounttextfield.text?.count == 0{
            showAlert(title: "", message: "Please Enter Amount", completion: nil)
           
        }
        else if purposetextfield.text?.count == 0{
            showAlert(title: "", message: "Please Select Purpose of Payment", completion: nil)
           
        }
        else if schemetextfield.text?.count == 0{
            showAlert(title: "", message: "Please Select Transaction Scheme", completion: nil)
        
        }
       else if GettPointofinitiationmethodstaticvalue == "11"
        {
           
           if selectedlist == "RAAST(Free)"
           {
               if IBANCode == "FMFB"
               {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalFundsTransferVC") as! LocalFundsTransferVC
                   vc.Transaction_amount = amounttextfield.text
                   vc.Transation_Scheme = selectedlist
                   vc.Purposeof_Transaction = sourceReasonForTrans
                   GetIBAN = GetIBAN?.substring(from: 8)
                  vc.User_IBAN = GetIBAN
                  isFromQR = "true"
                    self.navigationController?.pushViewController(vc, animated: true)
               }
               else{
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransferByAliasVC") as! TransferByAliasVC
                   vc.Transaction_amount = amounttextfield.text
                   vc.Transation_Scheme = selectedlist
                   vc.Purposeof_Transaction = sourceReasonForTrans
                  vc.User_IBAN = GetIBAN
                  isFromQR = "true"
                    self.navigationController?.pushViewController(vc, animated: true)
               }
            }
        else if selectedlist == "IBFT"{
               if IBANCode == "FMFB"
               {
                   showDefaultAlert(title: "Oops!", message:  "Invalid Transaction")
                  
               }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InterBankFundTransferVC") as! InterBankFundTransferVC
                vc.Transaction_amount = amounttextfield.text
                vc.Transation_Scheme = selectedlist
                vc.Purposeof_Transaction = sourceReasonForTrans
                vc.User_IBAN = GetIBAN
                vc.get_Bank_from_Sccaner = IBANCode!
                isFromQR = "true"
                self.navigationController?.pushViewController(vc, animated: true)
            }
              
           }
            
        }
        else  if GettPointofinitiationmethodstaticvalue == "12"
        {
            if selectedlist == "RAAST(Free)"
            {
                if IBANCode == "FMFB"
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalFundsTransferVC") as! LocalFundsTransferVC
                    vc.Transaction_amount = amounttextfield.text
                    vc.Transation_Scheme = selectedlist
                    vc.Purposeof_Transaction = sourceReasonForTrans
                    GetIBAN = GetIBAN?.substring(from: 8)
                   vc.User_IBAN = GetIBAN
                   isFromQR = "true"
                     self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransferByAliasVC") as! TransferByAliasVC
                    vc.Transaction_amount = amounttextfield.text
                    vc.Transation_Scheme = selectedlist
                    vc.Purposeof_Transaction = sourceReasonForTrans
                   vc.User_IBAN = GetIBAN
                   isFromQR = "true"
                     self.navigationController?.pushViewController(vc, animated: true)
                }
             }
            else  if selectedlist == "IBFT"{
                
                if IBANCode == "FMFB"
                {
                    showDefaultAlert(title: "Oops!", message:  "Invalid Transaction")
                   
                }
                else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InterBankFundTransferVC") as! InterBankFundTransferVC
                    vc.Transaction_amount = amounttextfield.text
                    vc.Transation_Scheme = selectedlist
                    vc.Purposeof_Transaction = sourceReasonForTrans
                    vc.User_IBAN = GetIBAN
                    vc.get_Bank_from_Sccaner = IBANCode!
                    isFromQR = "true"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
         }
        
    }
    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/PurposeOfTransaction"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<GetReaons>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetReaons>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.reasonObj = Mapper<GetReaons>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.reasonObj?.response == 2 || self.reasonObj?.response == 1 {
                        if let reasonCodes = self.reasonObj?.singleReason{
                            self.reasonsList = reasonCodes
                        }
                        
                        self.arrReasonsList = self.reasonObj?.stringReasons
                        
                        self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                        
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    
//                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                }
            }
        }
    }
    private func methodDropDownInquiries() {
          
        self.schemetextfield.placeholder = "Select".addLocalizableString(languageCode: languageCode)
        self.schemetextfield.selectedRowColor = UIColor.gray
        self.schemetextfield.rowBackgroundColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.schemetextfield.textColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.schemetextfield.textColor =   UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            self.schemetextfield.optionArray = ["RAAST(Free)", "IBFT"]
          
        self.schemetextfield.didSelect{ [self](b , index ,id) in
            self.schemetextfield.selectedRowColor = UIColor.gray
            self.selectedlist = b
            print("you select scheme ", b)
            self.schemetextfield.selectedRowColor = UIColor.gray
            
        }
    }
    private func methodDropDownReasons(Reasons:[String]) {
        
//        self.purposetextfield.placeholder = "Select Reasons"
        self.purposetextfield.rowHeight = 40.0
        self.purposetextfield.optionArray = Reasons
        self.purposetextfield.selectedRowColor = UIColor.gray
        self.purposetextfield.rowBackgroundColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.purposetextfield.textColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.purposetextfield.textColor =   UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.purposetextfield.didSelect{ [self](option , index ,id) in
            print("You Just select: \(option) at index: \(index)")
            self.sourceReasonForTrans = option
            print("you select reason ", option)
            Qr_transaction_Reason = option
            let code = self.purposetextfield
            for aCode in self.reasonsList {
//                if aCode.description == code {
//                    DataManager.instance.reasonForTrans = aCode.code
//                }
            }
        }
        
    }
    
    func breakString()
    {

        let mystring  = getString
        if mystring?.count ?? 0 > 54
        {
//            dynamic QRCode
            print("scanned QR is Dynamic")
            GetPayloadformatindicatorId =  mystring?.substring(to: 2)
            PayLoadIDLength = mystring?.substring(with:2..<4)
            GEtPayloadformatindicatorvalue = mystring?.substring(with:4..<6)
            Pointofinitiationmethodid = mystring?.substring(with:6..<8)
            InitiationMethodLength = mystring?.substring(with:8..<10)
            GettPointofinitiationmethodstaticvalue  = mystring?.substring(with:10..<12)
            GetSchemeidentifierid = mystring?.substring(with:12..<14)
            SchemeIdentifierLength = mystring?.substring(with:14..<16)
            GetSchemeidentifiervalue = mystring?.substring(with:16..<18)
            IGetBANid = mystring?.substring(with:18..<20)
            Iban_Length = mystring?.substring(with:20..<22)
            let d = mystring?.substring(from: 22)
            GetIBAN = d?.substring(with:0..<24)
            let leaveIban = GetIBAN?.substring(with:0..<8)
            IBANCode = leaveIban?.substring(with:4..<8)
//            IBANCode = "ZTBL"
//            return iban
            let rest_String = d?.substring(from: 24)
//            String(rest_String!.suffix(20))
            Getamountid = rest_String?.substring(to: 2)
            AmountCLenghtCount = rest_String?.substring(with: 2..<4)
            let getamount: Int?
            getamount = Int(AmountCLenghtCount!)
            let f = rest_String?.substring(from: 4)
            GetAmountValue = String(f!.prefix(getamount!))
//            071231082022165110049FBB
//            10050071231082022201510049FBB
            let x  = String(f!.suffix(24))
            Getexpirydateid = x.substring(to: 2)
            ExpiryDate_Length = x.substring(with: 2..<4)
            let g = x.substring(from: 4)
           date_fromstring = g.substring(to:12)
         
            Expiry_date = (date_fromstring as AnyObject).substring(to: 8)
            print("date is",Expiry_date)
            ShowData_AfterReadQR()
        }
       else
        {
//           print("scanned QR is Dynamic")
            GetPayloadformatindicatorId =  mystring?.substring(to: 2)
            PayLoadIDLength = mystring?.substring(with:2..<4)
            GEtPayloadformatindicatorvalue = mystring?.substring(with:4..<6)
            Pointofinitiationmethodid = mystring?.substring(with:6..<8)
            InitiationMethodLength = mystring?.substring(with:8..<10)
            GettPointofinitiationmethodstaticvalue  = mystring?.substring(with:10..<12)
            GetSchemeidentifierid = mystring?.substring(with:12..<14)
            SchemeIdentifierLength = mystring?.substring(with:14..<16)
            GetSchemeidentifiervalue = mystring?.substring(with:16..<18)
            IGetBANid = mystring?.substring(with:18..<20)
            Iban_Length = mystring?.substring(with:20..<22)
            let d = mystring?.substring(from: 22)
            GetIBAN = d?.substring(with:0..<24)
            let leaveIban = GetIBAN?.substring(with:0..<8)
            IBANCode = leaveIban?.substring(with:4..<8)
            ShowData_AfterReadQR()
       }
        
        
    }
    func ShowData_AfterReadQR()
    {
        lblIBAN.text = GetIBAN
        Tableview1.isHidden = false
       if GettPointofinitiationmethodstaticvalue == "11"

        {
           lblQRCodetype.text = "Static"
           lblIBAN.text = GetIBAN
           lbl_ExpiryDate.isHidden = true
           lbl_ExpiryValue.isHidden = true
       }
        else if GettPointofinitiationmethodstaticvalue == "12"
        {
            lbl_ExpiryDate.isHidden = false
            lbl_ExpiryValue.isHidden = false
            lblQRCodetype.text = "Dynamic"
            lbl_ExpiryValue.text =  date_fromstring
            amounttextfield.text = GetAmountValue
            amounttextfield.isUserInteractionEnabled = false
            CheckDate_Format()
        }
            
    }
    
    
    func CheckDate_Format()
     {
//         let date = Current_Date!
//         let a = date?.replacingOccurrences(of: " ", with: "")
//         let b = a?.replacingOccurrences(of: "-", with: "")
//         let Actual_Date = b?.replacingOccurrences(of: ":", with: "")
// //       020720220921
//         print("Actual date is ",Actual_Date!)
//        Current_Date = Actual_Date
//         if "\(Expiry_date)" <= "\(Actual_Date)"
//
//         {
//             self.showAlert(title: "Oops!", message: "Date is Expire", completion: {
//               self.navigationController?.popViewController(animated: true)
//             })
//         }
         let date = Current_Date!
         let a = (date as AnyObject).replacingOccurrences(of: " ", with: "")
         let b = a.replacingOccurrences(of: "-", with: "")
         var Actual_Date = b.replacingOccurrences(of: ":", with: "")
         Actual_Date = Actual_Date.replacingOccurrences(of: ".", with: "")
         //       020720220921
         print("Actual date is ",Actual_Date)
         Current_Date = Actual_Date
         Actual_Date = (Current_Date as AnyObject).substring(to: 8)
         let now = Date()
         if (Expiry_date as! String)  < (Actual_Date) {
             self.showAlert(title: "Oops!", message: "Date is Expire", completion: {
                 self.navigationController?.popViewController(animated: true)
             })
         } else {
             // valid
             print("valid - now: \(now) entered: \(Expiry_date)")
         }
     }
}
