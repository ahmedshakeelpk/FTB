//
//  ReadQRVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 18/07/2022.
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
var Qr_transaction_Reason : String?
class ReadQRVC: BaseVC , UINavigationControllerDelegate, UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate{
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
    var GetIBAN  :String?
    var IBANCode  :String?
    var Getamountid :String?
    var AmountCLenghtCount : String?
    var GetAmountValue: String?
    var Getexpirydateid :String?
    var ExpiryDate_Length : String?
    var Expiry_date: Any?
    var date_fromstring = ""
    var GetCRCid :String?
    var CRD_Length : String?
    var GetCRCvalue :String?
    var Get_Stringfrom_QRSccaner : String?
    var Transactionamount : Double?
    var Current_Date : Any??
    var getString : String?
    var reasonObj:GetReaons?
    var reasonsList = [SingleReason]()
    var arrReasonsList : [String]?
    var sourceReasonForTrans:String?
    var selectedlist : String?
    var imagePicker = UIImagePickerController()
    var pickImageCallback : ((UIImage) -> ())?;
    var Fetch_img : UIImage?
    var Ftech_String : String?
    var test : Any?
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    override func viewDidLoad() {
        super.viewDidLoad()
//        Tableview1.isHidden = true
        Changelanguage()
        getReasonsForTrans()
        methodDropDownInquiries()
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy-HH-mm"
        Current_Date = df.string(from: date)
        print("current date is", Current_Date!)
        print("image is" ,Fetch_img)
        print("string is,",Ftech_String)
        Read_Image()
        lbltitle.text = "ReadQR".addLocalizableString(languageCode: languageCode)
        btnprocess.setTitle("PROCESS".addLocalizableString(languageCode: languageCode), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lbl_ExpiryValue: UILabel!
    @IBOutlet weak var lbl_ExpiryDate: UILabel!
    @IBOutlet weak var btnupload: UIButton!
    @IBOutlet weak var lblIBAN: UILabel!
    @IBOutlet weak var lblQRCodetype: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnprocess: UIButton!
    @IBOutlet weak var schemetextfield: DropDown!
    @IBOutlet weak var purposetextfield: DropDown!
    @IBOutlet weak var amounttextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var lblValidation: UILabel!
    @IBOutlet weak var Tableview1: UITableView!
    @IBAction func backk(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func process(_ sender: UIButton) {
        if amounttextfield.text?.count == 0{
            showAlert(with: "", message: "Please Enter Amount")
        }
        else if purposetextfield.text?.count == 0{
            showAlert(with: "", message: "Please Select Purpose of Payment")
        }
        else if schemetextfield.text?.count == 0{
            showAlert(with: "", message: "Please Select Transaction Scheme")
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
            
            else if selectedlist == "IBFT"
            {
                if IBANCode == "FMFB"
                {
                    showDefaultAlert(title: "Oops!", message:  "Invalid Transaction")
                    
                }
                
                else
                
                {
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
                //
            }
            
            
            
            else if selectedlist == "IBFT"{
                if IBANCode == "FMFB"
                {
                    showAlert(with: "Oops!", message: "Invalid Transaction")
                }
                else
                {
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
    
    @IBAction func readqr(_ sender: UIButton) {
        let alert:UIAlertController = UIAlertController(title: "Which Scanner?", message: "Please from where you want to get the qr code info", preferredStyle: .actionSheet)
        let fromImageAction:UIAlertAction = UIAlertAction(title: "From Gallery", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
               let imagePicker:UIImagePickerController =  UIImagePickerController()
                          imagePicker.delegate = self
                          imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                          imagePicker.allowsEditing = true
//                self?.navigationController?.pushViewController(imagePicker, animated: true)
                          self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        alert.addAction(fromImageAction)
        
        self.present(alert,animated: true)
        
    }
    
        func Changelanguage()
        {
            lbltitle.text = "ReadQR".addLocalizableString(languageCode: languageCode)
            btnprocess.setTitle("PROCESS".addLocalizableString(languageCode: languageCode), for: .normal)
            btnupload.setTitle("UPLOAD QR IMAGE".addLocalizableString(languageCode: languageCode), for: .normal)
        }
    internal func showAlert(with title:String,message:String) {
        DispatchQueue.main.async {
            let alertControl =  UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel) { [unowned alertControl] _ in
                alertControl.dismiss(animated: true, completion: nil)
            }
            
            alertControl.addAction(okAction)
            self.present(alertControl,animated: true)
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
                Qr_transaction_Reason   = option
                
                print("you select reason ", option)

                let code = self.purposetextfield
                for aCode in self.reasonsList {
    //                if aCode.description == code {
    //                    DataManager.instance.reasonForTrans = aCode.code
    //                }
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
                //                Object { (response: DataResponse<GetReaons>) in
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
                            
                            //      self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                            //                    self.getTransactionConsent()
                        }
                        else {
                            // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                        }
                    }
                    else {
//                        print(response.result.value)
                        print(response.response?.statusCode)
                        
                        //                if let message =  self.shopInfo?.resultDesc{
                        //                    self.showAlert(title: Localized("error"), message: message, completion: nil)
                        //                }
                        //                else{
                        //                    self.showAlert(title: Localized("error"), message:Constants.ERROR_MESSAGE, completion: nil)
                        //                }
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
            date_fromstring = g.substring(to: 12)
            print("date is",date_fromstring)
            Expiry_date = g.substring(to:12)
            Expiry_date = (Expiry_date as AnyObject).substring(to: 8)
            print("date is",Expiry_date)
            ShowData_AfterReadQR()
                    }
       else
        {
           print("scanned QR is Static")
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
       func CheckDate_Format()
        {
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
//            let formatter = DateFormatter()
//            formatter.dateFormat = "ddMMyyyy" //apna date format rakho yhan
//
//            formatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale
//
//            let df = DateFormatter()
//            df.dateFormat = "dd-MM-yyyy"
//            let x = (Expiry_date as AnyObject).substring(to: 2)
//            var mon = (Expiry_date as AnyObject).substring(from: 2)
//            var ye = (Expiry_date as AnyObject).substring(from: 2)
//            mon = (mon as  AnyObject).substring(to: 2)
//            var year = (ye as AnyObject).substring(from: 2)
//            let  concate = "\(x)-\(mon)-\(year)"
//            let strdate1 = df.date(from: "03-10-2022 18:00:00" as! String)
//            let strDate2 = df.date(from: "26-09-2022 19:00:00" as! String)
//
//            let order = Calendar.current.compare(strDate2!, to:  strdate1!, toGranularity: .hour)
//            print("oder",order )FlblDate
            
       
            if (Expiry_date as! String)  < (Actual_Date) {
                self.showAlert(title: "Oops!", message: "Date is Expire", completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                // valid
                print("valid - now: \(now) entered: \(Expiry_date)")
            }
               
    }
    func Read_Image()
    {
        let res:TapQRCodeScannerResult = TapQRCodeScanner().scan(from: Fetch_img!)
        print(res.scannedText ?? "")
        if res.scannedText == "" &&  res.scannedText! <  "\(54)"
        {
            self.showAlert(with: "Oops!", message: "Invalid Image..")
        }
        else
        {
//                        self?.showAlert(with: "Scanned", message: res.scannedText ?? "")
            self.getString = res.scannedText
            self.imgview.image = Fetch_img
            self.breakString()
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
            lbl_ExpiryValue.text =   date_fromstring as! String
            amounttextfield.text = GetAmountValue
            amounttextfield.isUserInteractionEnabled = false
            CheckDate_Format()
            
        }
            
    }
//    func describeComparison(date1: Date, date2: Date) -> String {
//
//        var descriptionArray: [String] = []
//
//        if Expiry_date < Current_Date {
//            print("ok")
//        }
//
//        if date1 <= date2 {
//            descriptionArray.append("date1 <= date2")
//        }
//
//        if date1 > date2 {
//            descriptionArray.append("date1 > date2")
//        }
//
//        if date1 >= date2 {
//            descriptionArray.append("date1 >= date2")
//        }
//
//        if date1 == date2 {
//            descriptionArray.append("date1 == date2")
//        }
//
//        if date1 != date2 {
//            descriptionArray.append("date1 != date2")
//        }
//
//        return descriptionArray.joined(separator: ",  ")
//    }
  }
    
extension ReadQRVC {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        DispatchQueue.main.async { [unowned picker, weak self] in
//            self?.loadingActivity.isHidden = false
            picker.dismiss(animated: true) { [self] in
                if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                  
                    // imageViewPic.contentMode = .scaleToFill
                    let res:TapQRCodeScannerResult = TapQRCodeScanner().scan(from: pickedImage)
                    print(res.scannedText ?? "")
                    if res.scannedText == ""
                    {
                        self?.showAlert(with: "Oops!", message: "Invalid Image..")
                    }
                    else
                    {
//                        self?.showAlert(with: "Scanned", message: res.scannedText ?? "")
                        self?.getString = res.scannedText
                         self?.imgview.image = pickedImage
                        self?.breakString()
                    }
                   
                }
//                self?.loadingActivity.isHidden = true
            }
        }
    }
    
}
extension UIViewController {
  public func addActionSheetForiPad(actionSheet: UIAlertController) {
    if let popoverPresentationController = actionSheet.popoverPresentationController {
      popoverPresentationController.sourceView = self.view
      popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
      popoverPresentationController.permittedArrowDirections = []
    }
  }
}



