//
//  StaticQRVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/07/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import Photos
import SCLAlertView
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper
@available(iOS 13.0, *)
class StaticQRVC: BaseVC {
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
    var qrcodeImage: CIImage!
    var String_Combined = ""
    var qrEmvData = ""
    var result = ""
    var payloadIndicator = ""
    var pointOfInitiation = ""
    var schemeIdentifire = ""
    var iBAN = ""
    var Crc = ""
    var CRCvalue = ""
    var concatestring: String?
    var getiban : String?
    var FetchDatafromString = ""
    var ShowQR_ModelListObj : SowQr_Model?
    var ShowQRarray : [QR_ListData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAccNo.text = DataManager.instance.IBAN
        getlastfourdigitIBAN()
        lblAcctitle.text = "\(DataManager.instance.accountTitle ?? "")"
        lblfetchiban.text = "\(getiban ?? "")"
        //        concatestring = "\(PayloadformatindicatorId)\(PayLoadIDLength)\(Payloadformatindicatorvalue)\(Pointofinitiationmethodid)\(InitiationMethodLength)\(Pointofinitiationmethodstaticvalue)\(Schemeidentifierid)\(SchemeIdentifierLength)\(Schemeidentifiervalue)\(IBANid)\(Iban_Length)\(IBAN)\(CRCid)\(CRD_Length)\(CRCvalue)"
        String_Combined = "\("00")\("02")\("02")\("01")\("02")\("11")\("02")\("02")\("00")\("04")\("24")\(DataManager.instance.IBAN)\("10")\("04")"
        print("concate string is",  String_Combined)
        print("my string count is",  String_Combined)
        let tData = Data(String_Combined.utf8.map{$0})
        let crcString = String.init(format: "%04X", tData.CRC16())
        CRCvalue = crcString
        print(crcString)
        String_Combined = "\("00")\("02")\("02")\("01")\("02")\("11")\("02")\("02")\("00")\("04")\("24")\(DataManager.instance.IBAN)\("10")\("04")\(CRCvalue)"
        qrEmvData = String_Combined
        decodeEMVQR(qr: qrEmvData)
        result = "\(FetchDatafromString)"
        
        let myQRimage: UIImage? = UIImage(ciImage: createQRFromString(str: "\(result)")!)
        imgview.image = myQRimage
        Change_Langugage()
        
    }
    
    @IBOutlet weak var lblfetchiban: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var lblAcctitle: UILabel!
    @IBOutlet weak var qrview: UIView!
    @IBOutlet weak var btngenerateqr: UIButton!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var btndownload: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblDownload: UILabel!
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var lblAccountTotle: UILabel!
    @IBAction func generate(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateQR") as! GenerateQR
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_ReadQR(_ sender: UIButton) {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReadQRVC") as! ReadQRVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        //
        
        
    }
    
    func Change_Langugage()
    {
        lblMainTitle.text = "Thumbnail".addLocalizableString(languageCode: languageCode)
        lblAccountTotle.text = "Account No".addLocalizableString(languageCode: languageCode)
        lblDownload.text = "Download QR".addLocalizableString(languageCode: languageCode)
        lblShare.text = "Share".addLocalizableString(languageCode: languageCode)
        btngenerateqr.setTitle("GENERATE DYNAMIC QR".addLocalizableString(languageCode: languageCode), for: .normal)
        btnScan.setTitle("SCAN QR CODE".addLocalizableString(languageCode: languageCode), for: .normal)
        btnShow.setTitle("SHOW MY QR".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
        
    }
    
    
    @IBAction func Action_Share(_ sender: UIButton) {
        let image = qrview.screenshotImage()
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func Action_ShowQR(_ sender: UIButton) {
        //        Show_QRList()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Show_QrList") as!  Show_QrList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func image(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if (error != nil) {
            // Something wrong happened.
            showAlert(title: "", message: " Something wrong happened..", completion: nil)
        } else {
            showAlert(title: "", message: "Image Saved Successfully..", completion: nil)
        }
    }
    @IBAction func download(_ sender: UIButton) {
        //        captureScreen()
        let image = qrview.screenshotImage()
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
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
        var Crc = ""
        var staticQRValue : String?
        var crcValue : String?
        var ibanValue : String?
        var ConcateString : String?
        
        for (key, value) in dic {
            print("\(key) -> \(value)")
            
            if key == "01"
            {
                pointOfInitiation = "\(key)\("02")\(value)"
                staticQRValue = value
                print("dynamicQRValue", staticQRValue!)
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
            FetchDatafromString = "\(payloadIndicator)\(pointOfInitiation)\(schemeIdentifire)\(iBAN)\(Crc)"
            FetchDatafromString =   FetchDatafromString.replacingOccurrences(of: " ", with: "")
            print("output is",   FetchDatafromString)
            
            
            
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
    }
    
    func captureScreen() {
        
        var image :UIImage?
        image  = imgview.image
        //            let currentLayer = UIApplication.shared.keyWindow!.layer
        //            let currentScale = UIScreen.main.scale
        //            UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
        //            guard let currentContext = UIGraphicsGetCurrentContext() else {return}
        //            currentLayer.render(in: currentContext)
        //            image = UIGraphicsGetImageFromCurrentImageContext()
        //            UIGraphicsEndImageContext()
        guard let img = image else { return }
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false // if you dont want the close button use false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let button = alertView.addButton("Ok") {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            
            self.present(vc,animated:  true)
        }
        
        button.backgroundColor = UIColor(red: 60/255, green: 128/255, blue: 106/255, alpha: 1.0)
        showDefaultAlert(title: "", message: "Saved to Gallery")
        //            alertView.showCustom("", subTitle: ("Saved to Gallery"), color: UIColor(red: 0.8, green: 0, blue: 0, alpha: 1), icon: #imageLiteral(resourceName: "checkmark.png"))
        // UtilManager.showAlertMessage(message: "Saved to Gallery", viewController: self)
        
    }
    private func createQRFromString(str: String) -> CIImage? {
        
        let stringData = str.data(using: .utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        return filter?.outputImage
    }
    
    func getlastfourdigitIBAN()
    {
        if DataManager.instance.IBAN == "" || DataManager.instance.IBAN == nil{
            return
        }
        if DataManager.instance.IBAN != nil && DataManager.instance.IBAN != ""{
            var myString = (DataManager.instance.IBAN ?? "")
            myString.remove(at: myString.startIndex)
            //            let finalstring = myString.dropLast(19)
            //            let a = finalstring.dropFirst(0)
            //            getiban = "\(a)"
            //            print("getiban", getiban as Any)
            getiban = String(myString.suffix(4))
            
        }
        
    }
    
    
    @IBAction func Action_ScanQr(_ sender: UIButton) {
        //
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Scan_QRVC") as!  Scan_QRVC
        self.navigationController?.pushViewController(vc, animated: true)
        //
        
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Scanning_UplaodingVc") as!  Scanning_UplaodingVc
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func Show_QRList() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/QR/show"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<SowQr_Model>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<SowQr_Model>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.ShowQR_ModelListObj = Mapper<SowQr_Model>().map(JSONObject: json)
                    
                    //                self.ShowQR_ModelListObj = response.result.value
                    if self.ShowQR_ModelListObj?.response == 2 || self.ShowQR_ModelListObj?.response == 1 {
                        
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "Show_QrList") as! Show_QrList
                        
                        for data in self.ShowQR_ModelListObj!.dataQr!
                        {
                            let tem_obj = QR_ListData()
                            
                            tem_obj.name = data.name
                            tem_obj.iBan = data.iban
                            tem_obj.id = data.id
                            tem_obj.point_of_initiation = data.point_of_initiation
                            tem_obj.Expiry_date = data.expiry_date
                            tem_obj.amount = data.amount
                            self.ShowQRarray.append(tem_obj)
                            
                        }
                        let AData = self.ShowQR_ModelListObj?.dataQr
                        
                        vc.name = AData?[0].name
                        vc.amount = AData?[0].amount
                        vc.ExpiryDate = AData?[0].expiry_date
                        vc.point_of_initiation = AData?[0].point_of_initiation
                        vc.id = AData?[0].id
                        vc.iBan = AData?[0].iban
                        vc.arr = self.ShowQRarray
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        self.showAlert(title: "", message: (self.ShowQR_ModelListObj?.message) as! String, completion: nil)
                    }
                }
                else {
                    self.showAlert(title: "", message: ("Data not found") as! String, completion: {
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    })
                    
//                    print(response.result.value as Any)
                    print(response.response?.statusCode as Any)
                }
            }
        }
    }
}
class QR_ListData
{
    var name : String?
    var point_of_initiation : String?
    var Expiry_date : String?
    var amount : String?
    var id : Int?
    var iBan : String?
    
}
