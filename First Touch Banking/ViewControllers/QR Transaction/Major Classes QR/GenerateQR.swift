//
//  GenerateQR.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/07/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import Photos
import Toaster
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class GenerateQR: BaseVC , UITextFieldDelegate{
    var amountValue : String?
    var crcValue : String?
    var dateValue : String?
    var dynamicQRValue : String?
    var ibanValue : String?
    var ConcateString : String?
    var FetchDatafromString = ""
    let crc_table: [UInt16] = [
        
        0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
        0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
        0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
        0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
        0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
        0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
        0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
        0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
        0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
        0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
        0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
        0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
        0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
        0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
        0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
        0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,
        0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
        0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
        0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
        0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
        0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
        0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
        0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
        0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
        0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
        0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
        0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
        0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
        0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
        0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
        0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
        0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0
    ]
    var dateFrom = NSDate()
    var dateTo = NSDate()
    var isFrom:String?
    var amount :String?
    var dateexpiry: String?
    
    var AccountNo : String?
    var CurrentDate  : String?
    var qrcodeImage: CIImage!
    var CRCvalue : String?
    var Iban_firstDigit : String?
    var Assign_View : UIImage?
    var Endoding_Img : String?
    var date_passtoAPi : String?
    var CreateQR_ModelListObj : Create_QR?
    var Array = [UInt8].self
    var String_Combined = ""
    var Access_crcClass =  CRC16()
    var qrEmvData = ""
    var result = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAccNo.text = DataManager.instance.IBAN
        lblAcctitle.text = DataManager.instance.accountTitle
        qrview.isHidden = true
        btndownload.isHidden = true
        datePicke.minimumDate = Date()
        datePicke.isHidden = true
        amounttextfield.delegate = self
        Name_Tfield.delegate = self
        Name_Tfield.keyboardType = .alphabet
        expirydate.delegate = self
        CHANGE_LAnguage()
        
        
    }
    
    @IBOutlet weak var lbl_lastDigitIban: UILabel!
    @IBOutlet weak var datePicke: UIDatePicker!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var lblAcctitle: UILabel!
    @IBOutlet weak var qrview: UIView!
    @IBOutlet weak var btngenerateqr: UIButton!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var expirydate: UITextField!
    @IBOutlet weak var btndownload: UIButton!
    @IBOutlet weak var Name_Tfield: UITextField!
    var t = ""
    
    func CHANGE_LAnguage()
    {
        lblMainTitle.text = "GENERATE QR".addLocalizableString(languageCode: languageCode)
        btndownload.setTitle("DOWNLOAD QR CODE".addLocalizableString(languageCode: languageCode), for: .normal)
        btngenerateqr.setTitle("GENERATE QR CODE".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    
    
    @IBAction func generate(_ sender: UIButton) {
        
        if amounttextfield.text?.count == 0 {
            self.showToast(title: "Please Enter Transaction Amount")
            
        }
        else  if expirydate.text?.count == 0
        {
            self.showToast(title: "Please Select Date")
        }
        else  if Name_Tfield.text?.count == 0
        {
            self.showToast(title: "Please Enter Name")
        }
        
        else{
            //            showAlert(title: "", message: "If you want to change Amount and date please do Immetidiate!") {
            //
            //            }
            let consentAlert = UIAlertController(title: "", message: "Do you want to Generate QR Code?".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
            
            consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { [self] (action: UIAlertAction!) in
                self.concateData()
                amounttextfield.isUserInteractionEnabled = false
                expirydate.isUserInteractionEnabled = false
                datePicke.isUserInteractionEnabled = false
                
            }))
            
            consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
                //            print("Handle Cancel Logic here")
                self.dismiss(animated: true, completion:nil)
            }))
            
            self.present(consentAlert, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func _DatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        print(sender.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy/HH:mm"
        formatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        let strdate1 = formatter.string(from: sender.date)
        print(strdate1)
        dateexpiry = strdate1
        let date = dateexpiry?.substring(to: 10)
        expirydate.text = date
        date_passtoAPi = date
        print("date_passtoAPi is ",  date_passtoAPi!)
        let a = dateexpiry?.replacingOccurrences(of: " ", with: "")
        let b = a?.replacingOccurrences(of: "/", with: "")
        let Actual_Date = b?.replacingOccurrences(of: ":", with: "")
        print("Actual date is ",Actual_Date!)
        let SaveActual_Date_userDeafult = UserDefaults.standard.set(amounttextfield.text, forKey: Actual_Date ?? "")
        print("SaveActual_Date_userDeafult is ",SaveActual_Date_userDeafult)
        dateexpiry = Actual_Date
        UserDefaults.standard.set(dateexpiry, forKey: "ExpiryDateQR")
        DataManager.instance.expirydateqrcode =  b
        print("saved date", DataManager.instance.expirydateqrcode)
    }
    
    
    @IBAction func download(_ sender: UIButton) {
        
        let consentAlert = UIAlertController(title: "", message: "Do you want to Download QR Code?".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { [self] (action: UIAlertAction!) in
            
            
            let  img =  convertBase64StringToImage(imageBase64String: Endoding_Img!)
            print("decod img is", img)
            self.qrview.setNeedsDisplay()
            var  testImage = img
            let afterconvert = self.qrview?.screenshotImage()
            let image = afterconvert
            let imageToShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
            //            self.navigationController?.popToRootViewController(animated: true)
            self.present(activityViewController, animated: true, completion: nil)
            
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            //            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
        //        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion:
                        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
        
    }
    
    @IBAction func amounttext(_ sender: UITextField) {
        UserDefaults.standard.set(amounttextfield.text, forKey: "AmountQr")
        DataManager.instance.Amount_Value = Double(amounttextfield.text!)
        print("saved amount",       DataManager.instance.Amount_Value)
        amount = amounttextfield.text!
        //        Amount_Length = String(amounttextfield.text!.count)
        //        if Int(Amount_Length!)! < 10
        //        {
        //            Amount_Length = "0\(Amount_Length!)"
        //        }
        datePicke.isHidden = false
        
    }
    var Return_Amountlength = ""
    func concateData()
    {
        var Amount_Length = (amounttextfield.text?.count)
        if (Amount_Length ?? -1) < 10
        {
            Return_Amountlength = ("0\(Amount_Length ?? 0)")
            
        }
        else
        {
            Return_Amountlength = String(amounttextfield.text!.count)
        }
        
        
        String_Combined = "\("00")\("02")\("02")\("01")\("02")\("12")\("02")\("02")\("00")\("04")\("24")\(DataManager.instance.IBAN)\("05")\( Return_Amountlength)\(amounttextfield.text!)\("07")\("12")\(dateexpiry!)\("10")\("04")"
        //    ConcateString = "\(PayloadformatindicatorId)\(PayLoadIDLength)\(Payloadformatindicatorvalue)\(Pointofinitiationmethodid)\(InitiationMethodLength)\(Pointofinitiationmethodstaticvalue)\(Schemeidentifierid)\(SchemeIdentifierLength)\(Schemeidentifiervalue)\(IBANid)\(Iban_Length)\(IBAN)\(amountid)\(Amount_Length!)\(amounttextfield.text!)\(expirydateid)\(ExpiryDate_Length)\( dateexpiry!)\(CRCid)\(CRD_Length)"
        //        print("my string is", ConcateString!)
        
        
        print("my string count is", t.count as Any)
        print("my string count is", String_Combined.count as Any)
        //    Iban_firstDigit = String(IBAN.prefix(5))
        //    Iban_firstDigit = Iban_firstDigit?.substring(from: 1)
        self.qrview.isHidden = false
        self.qrview.isHidden = false
        self.btndownload.isHidden = false
        self.qrview.dropShadow1()
        
        let tData = Data(String_Combined.utf8.map{$0})
        let crcString = String.init(format: "%04X", tData.crc16Check())
        
        CRCvalue = crcString
        UserDefaults.standard.set(CRCvalue, forKey: "CRCvalue")
        
        DataManager.instance.Qr_Crc = CRCvalue!
        print(crcString)
        String_Combined = "\("00")\("02")\("02")\("01")\("02")\("12")\("02")\("02")\("00")\("04")\("24")\(DataManager.instance.IBAN)\("05")\( Return_Amountlength)\(amounttextfield.text!)\("07")\("12")\(dateexpiry!)\("10")\("04")\(CRCvalue!)"
        
        //        ConcateString = "\(PayloadformatindicatorId)\(PayLoadIDLength)\(Payloadformatindicatorvalue)\(Pointofinitiationmethodid)\(InitiationMethodLength)\(Pointofinitiationmethodstaticvalue)\(Schemeidentifierid)\(SchemeIdentifierLength)\(Schemeidentifiervalue)\(IBANid)\(Iban_Length)\(IBAN)\(amountid)\(Amount_Length!)\(amounttextfield.text!)\(expirydateid)\(ExpiryDate_Length)\( dateexpiry!)\(CRCid)\(CRD_Length)\(CRCvalue!)"
        //        String_Combined = "0002020102120202000424PK21FMFB002112284650101605011071221092022235910040424"
        
        
        print("my string is after crc value", String_Combined)
        qrEmvData = String_Combined
        decodeEMVQR(qr: qrEmvData)
        result = "\(FetchDatafromString)"
        print(decodeEMV(qrData: qrEmvData)!)
        
        let myQRimage: UIImage? = UIImage(ciImage: createQRFromString(str: "\(self.result)")!)
        Endoding_Img =  convertImageToBase64String(img: myQRimage!)
        print("converted image is ", Endoding_Img)
        self.imgview.setNeedsDisplay()
        self.imgview.layoutIfNeeded()
        self.imgview.setNeedsLayout()
        self.qrview.setNeedsDisplay()
        self.qrview.setNeedsLayout()
        self.qrview.layoutIfNeeded()
        self.imgview.image = myQRimage
        
        self.lblamount.text = "Rs: \(self.amounttextfield.text!)"
        //        self.lbl_lastDigitIban.text = self.Iban_firstDigit
        let a = DataManager.instance.IBAN
        self.lbl_lastDigitIban.text =  String(a.suffix(4))
        //        print(crc16ccitttt(data: ConcateString!.utf8.map{$0}, seed: 0x1021, final: 0xffff))
        //
        self.generate_Qrs()
        
        print("now check")
        
        //        print(crc16ccitttt(data: ConcateString!.utf8.map{$0}, seed: 0x1D0F, final:  0xffff))
    }
    
    
    private func createQRFromString(str: String) -> CIImage? {
        
        let stringData = str.data(using: .utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        return filter?.outputImage
    }
    func decodeEMVQR(qr: String) {
        guard let dic = decodeEMV(qrData: qr) else {
            print("Error")
            return
        }
        var payloadIndicator = ""
        var pointOfInitiation = ""
        var schemeIdentifire = ""
        var iBAN = ""
        var Amount = ""
        var DateFetch = ""
        var Crc = ""
        
        for (key, value) in dic {
            print("\(key) -> \(value)")
            
            
            
            if key == "07"
            {
                DateFetch = "\(key)\("12")\(value)"
                dateValue = value
                print("dateValue", dateValue!)
            }
            else if key  == "05"
            {
                if value.count < 10
                {
                    
                    Amount = "\(key)\("0")\(value.count)\(value)"
                    //                    Amount = "\(key)\(value.count)\(value)"
                    lblamount.text = value
                }
                else
                {
                    Amount = "\(key)\(value.count)\(value)"
                    lblamount.text = value
                }
                
                amountValue = value
                print("amountValue", amountValue!)
            }
            else if key == "01"
            {
                pointOfInitiation = "\(key)\("02")\(value)"
                dynamicQRValue = value
                print("dynamicQRValue", dynamicQRValue!)
            }
            else if key == "10"
            {
                Crc = " \(key)\("04")\(value)"
                crcValue = value
                print("crcValue", crcValue!)
            }
            else if key  == "00"
            {
                payloadIndicator = " \(key)\("02")\(value)"
            }
            else if key  == "02"
            {
                schemeIdentifire = "\(key)\("02")\(value)"
            }
            else if key  == "04"
            {
                print("iban")
                ibanValue  = value
                iBAN = "\(key)\("24")\(value)"
            }
            
            
        }
        
        FetchDatafromString = "\(payloadIndicator)\(pointOfInitiation)\(schemeIdentifire)\(iBAN)\(Amount)\(DateFetch)\(Crc)"
        FetchDatafromString =   FetchDatafromString.replacingOccurrences(of: " ", with: "")
        print("output is",   FetchDatafromString)
        if String_Combined ==   FetchDatafromString
        {
            print("equal")
        }
        
        
        //        keys.forEach({
        //            let key = $0.key
        //            if let value = dic[key] {
        //                if emvKeys.contains($0.key), let dic = decodeEMV(qrData: value) {
        //                    dic.enumerated().forEach({
        //                        if let _key = keys[key] {
        //                            print("\(_key) \($0.element.key) = \($0.element.value)")
        //
        //                        }
        //                    })
        //                } else {
        //                    print("\($0.value) = \(value)")
        //                }
    }
    
    
    
    func parseData(data: String) -> (String, String, String)? {
        let keyIndex = data.index(data.startIndex, offsetBy: 1)
        let key = String(data[...keyIndex])
        
        let tempStartIndex = data.index(data.startIndex, offsetBy: 2)
        let temp = String(data[tempStartIndex...])
        
        let lengthIndex = temp.index(temp.startIndex, offsetBy: 1)
        if let length = Int(String(temp[...lengthIndex])) {
            let valueStartIndex = temp.index(temp.startIndex, offsetBy: 2)
            let valueEndIndex = temp.index(temp.startIndex, offsetBy: 1 + length)
            let value = String(temp[valueStartIndex...valueEndIndex])
            
            let newDataIndex = temp.index(temp.startIndex, offsetBy: 2 + length)
            let newData = String(temp[newDataIndex...])
            
            return (key, value, newData)
        }
        
        return nil
    }
    
    //    var arr = dic.map { "\($0.key) \($0.value)" }
    var arr = [String]()
    
    func decodeEMV(qrData: String) -> [String:String]? {
        var data = qrData
        var dic : [String: String] = [String:String]()
        //        var dic = [String:String]()
        
        while data.isEmpty == false {
            if let dataParsed = parseData(data: data) {
                data = dataParsed.2
                if dataParsed.0.isEmpty == false, dataParsed.1.isEmpty == false{
                    dic[dataParsed.0]  =   dataParsed.1
                    print("get text is",  dic[dataParsed.0])
                }
                
            } else {
                data = ""
            }
            
        }
        print("errorr")
        return dic
        print("text")
    }
    
    
    
    
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = UIImageJPEGRepresentation(img, 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    private func generate_Qrs() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/QR/create"
        //        20220707
        let params = ["payload_format":"14","point_of_initiation":"1","scheme_identifier":"16", "crc": CRCvalue!, "name": Name_Tfield.text!, "amount":amounttextfield.text! ,"expiry_date": "\(date_passtoAPi!)" ] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Create_QR>) in
        
        AF.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Create_QR>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.CreateQR_ModelListObj = Mapper<Create_QR>().map(JSONObject: json)
                    
                    if self.CreateQR_ModelListObj?.response == 2 || self.CreateQR_ModelListObj?.response == 1 {
                        print("Qr Create Scussfully..")
                        if let message = self.CreateQR_ModelListObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        
                    }
                    else {
                        if let message = self.CreateQR_ModelListObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
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
    func EncryptString(stringToEncrypt: String) ->String {
        
        var hexStr = ""
        
        
        // convert the string to encrypt into utf8 bytes
        let bytes = stringToEncrypt.data(using: String.Encoding.utf8, allowLossyConversion:false)
        var buf : [UInt8] = Swift.Array(bytes!)
        
        
        
        // turn the now encrypted "stringToEncrypt" into two character hex values in a string
        for byte in buf {
            hexStr.append(String(format:"%4X", byte))
        }
        
        // return the encrypted hex encoded string to the caller...
        return hexStr
        print("hexStr", hexStr)
    }
}
extension UIView {
    func screenshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
extension String {
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
}
extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self {
        return filter(("0"..."9").contains)
    }
}

extension RangeReplaceableCollection where Self: StringProtocol {
    mutating func removeAllNonNumeric() {
        removeAll { !("0"..."9" ~= $0) }
    }
}
extension String {
    
    func removeAlphabet() -> String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
}
extension Data {
    
    typealias bit_order_16 = (_ value: UInt16) -> UInt16
    typealias bit_order_8 = (_ value: UInt8) -> UInt8
    
    
    func crc16Check() -> UInt16 {
        let data = self as! NSData
        let bytes = UnsafePointer<UInt8>(data.bytes.assumingMemoryBound(to: UInt8.self))
        let length = data.length
        return crc16ccitt(message: bytes, nBytes: length)
    }
    
    
    func straight_16(value: UInt16) -> UInt16 {
        return value
    }
    
    func reverse_16(value: UInt16) -> UInt16 {
        var value = value
        var reversed: UInt16 = 0
        for i in stride(from: 0, to: 16, by: 1) {
            reversed <<= 1
            reversed |= (value & 0x1)
            value >>= 1
        }
        return reversed
    }
    
    func straight_8(value: UInt8) -> UInt8 {
        return value
    }
    
    func reverse_8(value: UInt8) -> UInt8 {
        var value = value
        var reversed: UInt8 = 0
        for i in stride(from: 0, to: 8, by: 1) {
            reversed <<= 1
            reversed |= (value & 0x1)
            value >>= 1
        }
        return reversed
    }
    
    
    func crc16(message: UnsafePointer<UInt8>, nBytes: Int, data_order: bit_order_8, remainder_order: bit_order_16, remainder: UInt16, polynomial: UInt16) -> UInt16 {
        var remainder = remainder
        
        for byte in stride(from: 0, to: nBytes, by: 1) {
            
            remainder ^= UInt16(data_order(message[byte]) << 8)
            var bit = 8
            while bit > 0 {
                if (remainder & 0x8000) != 0 {
                    remainder = (remainder << 1) ^ 0x1021
                } else {
                    remainder = (remainder << 1)
                }
                bit -= 1
            }
        }
        
        return remainder_order(remainder)
    }
    func CRC16() -> UInt16 {
        let table: [UInt16] = [
            0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
            0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
            0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
            0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
            0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
            0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
            0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
            0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
            0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
            0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
            0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
            0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
            0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
            0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
            0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
            0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,
            0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
            0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
            0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
            0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
            0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
            0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
            0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
            0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
            0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
            0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
            0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
            0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
            0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
            0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
            0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
            0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0
        ]
        var crc = UInt16(0)
        var temp = UInt16(0)
        self.forEach { byte in
            temp = UInt16(byte) ^ (crc >> 8) & 0xFF
            crc = UInt16(table[Int(temp)]) ^ (crc << 8)
        }
        return UInt16((crc ^ 0) & 0xFFFF)
    }
    
    
    func crc16ccitt(message: UnsafePointer<UInt8>, nBytes: Int) -> UInt16 {
        
        return crc16(message: message, nBytes: nBytes, data_order: straight_8, remainder_order: straight_16, remainder: 0xFFFF, polynomial: 0x1021)
        
    }
    
    func crc16ccitt_xmodem(message: UnsafeMutablePointer<UInt8>, nBytes: Int) -> UInt16 {
        return crc16(message: message, nBytes: nBytes, data_order: straight_8, remainder_order: straight_16, remainder: 0x0000, polynomial: 0x1021)
    }
    
    func crc16ccitt_kermit(message: UnsafeMutablePointer<UInt8>, nBytes: Int) -> UInt16 {
        let swap = crc16(message: message, nBytes: nBytes, data_order: reverse_8, remainder_order: reverse_16, remainder: 0x0000, polynomial: 0x1021)
        return swap << 8 | swap >> 8
    }
    
    func crc16ccitt_1d0f(message: UnsafeMutablePointer<UInt8>, nBytes: Int) -> UInt16 {
        return crc16(message: message, nBytes: nBytes, data_order: straight_8, remainder_order: straight_16, remainder: 0x1d0f, polynomial: 0x1021)
    }
    
    func crc16ibm(message: UnsafeMutablePointer<UInt8>, nBytes: Int) -> UInt16 {
        return crc16(message: message, nBytes: nBytes, data_order: reverse_8, remainder_order: reverse_16, remainder: 0x0000, polynomial: 0x8005)
    }
}
