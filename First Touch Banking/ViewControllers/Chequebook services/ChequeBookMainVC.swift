//
//  ChequeBookMainVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper

class ChequeBookMainVC: BaseVC {
    var isfromEStatement  = ""
    var ATMID : String?
    var MBID : String?
    var newreqOBj : NewRequest?
    var genericObj: GenericResponse?
    var SmsObj : SMSModel?
    var arrMBItems = [MB]()
    var arrATMItems = [ATM]()
    var LimitManagmentObj : AtmMobilebankingModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Backpressed(_ sender: UIButton) {
        if isfromEStatement == "true"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"HomeVC") as! HomeVC
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    @IBOutlet weak var lblmain: UILabel!
    func ChangeLanguage()
    {
        lblmain.text = "ChequeBook".addLocalizableString(languageCode: languageCode)
        btnCheckBookRe.setTitle("ChequeBook Request".addLocalizableString(languageCode: languageCode), for: .normal)
        btnCheckBookStatus.setTitle("ChequeBook Status".addLocalizableString(languageCode: languageCode), for: .normal)
        BtnStopPayment.setTitle("Stop Payment".addLocalizableString(languageCode: languageCode), for: .normal)
        checkLeafInq.setTitle("ChequeLeaf Inquiry".addLocalizableString(languageCode: languageCode), for: .normal)
        btnmainenance.setTitle("Account Maintenance Cerificate".addLocalizableString(languageCode: languageCode), for: .normal)
        btnWHT.setTitle("WHT Calculations".addLocalizableString(languageCode: languageCode), for: .normal)
        btnSMS.setTitle("SMS Subcription".addLocalizableString(languageCode: languageCode), for: .normal)
        btnEstatment.setTitle("E Statment".addLocalizableString(languageCode: languageCode), for: .normal)
        btnLimit.setTitle("Account Limit Management".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    //    MARK: API
    
    
    //    END
    
    
    @IBOutlet weak var btnCheckBookRe: UIButton!
    @IBAction func CheckBookRequest(_ sender: UIButton) {
        //
        let consentAlert = UIAlertController(title: "ChequeBook NewRequest", message: "Charges will be deducted as per SOC 7/- per Leaf".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ChequeBookRequestVc") as! ChequeBookRequestVc
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        //
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            //            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
        //        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var btnCheckBookStatus: UIButton!
    @IBAction func btnCheckBookStatus(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"StatusCheckVC") as! StatusCheckVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func StopPayment(_ sender: UIButton) {
        //
        let consentAlert = UIAlertController(title: "ChequeBook StopPayment", message: "Charges will be deducted as per SOC 150/- per Request".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"StopPaymentVC") as! StopPaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            //            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
        //        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func checkLeaf(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"CheckLeafVC") as! CheckLeafVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var checkLeafInq: UIButton!
    
    @IBOutlet weak var btnmainenance: UIButton!
    
    @IBAction func maintananceCertification(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"MaintenanceCertificationVc") as! MaintenanceCertificationVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var btnWHT: UIButton!
    @IBAction func WHTCalculations(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"WHTtaxVC") as! WHTtaxVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var btnSMS: UIButton!
    
    @IBAction func SMS(_ sender: UIButton) {
        
        let consentAlert = UIAlertController(title: "SMS Subcription", message: "Charges will be deducted as per SOC 350/- Annually".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            self.SMSSubcribtion()
            
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            //            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
        //        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var btnEstatment: UIButton!
    
    @IBAction func Estatment(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"E_StatmentVC") as! E_StatmentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBOutlet weak var btnLimit: UIButton!
    
    @IBAction func limitManagment(_ sender: UIButton) {
        
        //        call api
        getChannelLimits()
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier:"LimitManagementMainVc") as! LimitManagementMainVc
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func getChannelLimits() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/getAccountLimits"
        
        let parameters = ["lat": DataManager.instance.Latitude!,"lng": DataManager.instance.Longitude!,"imei": DataManager.instance.imei!] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        //        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        //        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).response { response in
            //        Object { (response: DataResponse<AtmMobilebankingModel>) in
            
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<AtmMobilebankingModel>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.LimitManagmentObj = Mapper<AtmMobilebankingModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.LimitManagmentObj?.response == 2 || self.LimitManagmentObj?.response == 1 {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"LimitManagementMainVc") as! LimitManagementMainVc
                        vc.arrMBItems =  self.LimitManagmentObj?.data?.mB ?? []
                        vc.arrATMItems = self.LimitManagmentObj?.data?.aTM ?? []
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    else {
                        if let message = self.LimitManagmentObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.LimitManagmentObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
    
    @IBOutlet weak var BtnStopPayment: UIButton!
    private func SMSSubcribtion(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "/api/v1/Customers/SMSSubscription"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        //        NetworkManager.sharedInstance.enableCertificatePinning()
        //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
        //
        //        thekkrna h
        AF.request(compelteUrl, headers:header).response { response in
            //         Object { (response: DataResponse<SMSModel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.SmsObj = Mapper<SMSModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.SmsObj?.response == 2 || self.SmsObj?.response == 1 {
                        
                        
                        if let message = self.SmsObj?.message{
                            self.showDefaultAlert(title: "", message:message)
                        }
                    }
                    else {
                        if let message = self.SmsObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.SmsObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
