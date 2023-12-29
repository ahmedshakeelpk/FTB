//
//  Show_QrList.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 17/08/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SCLAlertView
import CoreMIDI
import AVFoundation
import OpalImagePicker
import ObjectMapper

@available(iOS 13.0, *)
class Show_QrList: BaseVC,UITableViewDelegate, UITableViewDataSource, AVCaptureMetadataOutputObjectsDelegate, OpalImagePickerControllerDelegate{
    var FetchDatafromString = ""
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
//        return arr.count
    return ShowQR_ModelListObj?.dataQr?.count ?? 0
    
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let aCell = tableView.dequeueReusableCell(withIdentifier: "Cell_showQr") as! Cell_showQr
    aCell.selectionStyle = .none
    aCell.dropShadow1()
    aCell.btn_Download.tag = indexPath.row
    let AData = ShowQR_ModelListObj?.dataQr
    aCell.lbl_Title.text = ShowQR_ModelListObj?.dataQr?[indexPath.row].name
    aCell.lbl_Date.text = ShowQR_ModelListObj?.dataQr?[indexPath.row].expiry_date
    aCell.lbl_Amount.text = ShowQR_ModelListObj?.dataQr?[indexPath.row].amount
    qrEmvData = String_Combined
//    decodeEMVQR(qr: qrEmvData)
//    result = FetchDatafromString
    aCell.btn_Download.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
    
    let myQRimage: UIImage? = UIImage(ciImage: createQRFromString(str: "\(self.qrEmvData ?? "")")!)
    var test = myQRimage as UIImage?
    aCell.img_Qr.image = test as UIImage?
//    aCell.img_Qr.image = UIImage(named: "new logo")
    return aCell
}
    
    var arr = [QR_ListData]()
    var name : String?
    var point_of_initiation : String?
    var Expiry_date : String?
    var amount : String?
    var id : Int?
    var iBan : String?
    var ShowQR_ModelListObj : SowQr_Model?
    var Fetch_data : Save_data_from_API?
    var qrEmvData = ""
    var String_Combined = ""
    var result = ""
    var  Return_Amountlength = ""
    var ExpiryDate =  UserDefaults.standard.string(forKey: "ExpiryDateQR")
    var MyString: String?
    var myqrlist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 150
        Show_QRList()
//        tableview.reloadData()
//      ExpiryDate = String(ExpiryDate!.prefix(8))
        print("expiry is", ExpiryDate)
        Main_Title.text = "Show_QrList".addLocalizableString(languageCode: languageCode)
        print("data is ", arr)
        
     
    }
    @IBOutlet weak var tableview: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    @IBOutlet weak var testimgview: UIImageView!
    override func viewWillDisappear(_ animated: Bool) {
        tableview.reloadData()
    }
    @IBAction func Action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBOutlet weak var Main_Title: UILabel!
    @IBAction func Action_Download(_ sender: UIButton) {
    }
    
    @objc func btnClicked(_sender:UIButton)
    {
        let tag = _sender.tag
        let consentAlert = UIAlertController(title: "", message: "Do you want to Download QR Code?".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { [self] (action: UIAlertAction!) in
            let index = NSIndexPath(item: 0, section: 0)
            tableview.reloadData()
            let refCell = tableview.cellForRow(at: IndexPath(row: tag, section: 0)) as! Cell_showQr
            let afterconvert = refCell.qrview.screenshotImage()
            let image = afterconvert
            let imageToShare = [ image ]
                     let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                     activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

                     // exclude some activity types from the list (optional)
                     activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
             
        }))
        
        
      
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
//        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion: nil)
    }
    
    
    func Concate_Data()
    {

            for i in ShowQR_ModelListObj!.dataQr!
            {
                var Fetch_CRC =  UserDefaults.standard.string(forKey: "CRCvalue")
                print("crc",Fetch_CRC)
                var fetchamount = i.amount
                var finalDate = i.expiry_date!
                if fetchamount != nil && finalDate != nil
                {
                    var Amount_Length = (fetchamount!.count)
                    if (Amount_Length ?? -1) < 10
                           {
                        Return_Amountlength = ("0\(Amount_Length ?? 0)")
                       
                           }
                    else
                    {
                        Return_Amountlength = String(ShowQR_ModelListObj?.dataQr?[0].amount?.count ?? 0)
                    }
                }
                finalDate = finalDate.replace(string: "-", replacement: "")
                finalDate = finalDate.replace(string: " ", replacement: "")
                finalDate = finalDate.replace(string: ":", replacement: "")
                finalDate = String(finalDate.prefix(12))
               
                String_Combined = "\("00")\("02")\("02")\("01")\("02")\("12")\("02")\("02")\("00")\("04")\("24")\(i.iban ?? "")\("05")\(Return_Amountlength)\(fetchamount!)\("07")\("12")\(finalDate)\("10")\("04")\(Fetch_CRC!)"
                print("String_Combined",     String_Combined)
                
                myqrlist.append(String_Combined)
                
            }
           
//            ShowQR_ModelListObj?.dataQr?[0].point_of_initiation! ?? ""
//            var fetchAmount = ShowQR_ModelListObj?.dataQr?[0].amount! ?? ""
         
    }
    func share() {
        let activityItems = [
            "Title",
            "Body",
            UIImage(systemName: "keyboard")!,
            UIImage(systemName: "square.and.arrow.up")!
        ] as [Any]
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    private func createQRFromString(str: String) -> CIImage? {

        let stringData = str.data(using: .utf8)
               let filter = CIFilter(name: "CIQRCodeGenerator")
               filter?.setValue(stringData, forKey: "inputMessage")
               filter?.setValue("H", forKey: "inputCorrectionLevel")
               
               return filter?.outputImage
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
        
        //        NetworkManager.sharedInstance.enableCertificatePinning()
        //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<SowQr_Model>) in
        AF.request(compelteUrl, headers:header).response { response in
            //            Object { [self] (response: DataResponse<SowQr_Model>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.ShowQR_ModelListObj = Mapper<SowQr_Model>().map(JSONObject: json)
                    
                    if self.ShowQR_ModelListObj?.response == 2 || self.ShowQR_ModelListObj?.response == 1 {
                        self.tableview.reloadData()
                        self.Concate_Data()
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
        var amountValue : String?
        var crcValue : String?
        var dateValue : String?
        var dynamicQRValue : String?
        var ibanValue : String?
        var ConcateString : String?
        
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
                    
                }
                else
                {
                    Amount = "\(key)\(value.count)\(value)"
                   
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

class Save_data_from_API
{
    var id : Int?
    var point_of_initiation : String?
    var name : String?
    var iban : String?
    var amount : String?
    var expiry_date : String?
    
    
    
}
extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
}
