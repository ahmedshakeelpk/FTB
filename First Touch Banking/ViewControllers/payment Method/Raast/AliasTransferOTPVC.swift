//
//  AliasTransferOTPVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 31/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper
class AliasTransferOTPVC: BaseVC, UITextFieldDelegate {
    var genRespBaseObj : GenericResponse?
    var sourceAccount:String?
    var beneficaryAccount:String?
    var benealias : String?
    var bebeiban :String?
    var transferAmount:String?
    var reason : String?
    var sourceiban : String?
    var sourceAccTitle: String?
    var sourceAccountTitle : String?
    var uniquekey : String?
    var mid : String?
    var FundTransferobj : FundTransfer?
    var uniquekeyy : String?
    var Bankname : String?
    var TransationByAliasModelobj : TransationByAliasModel?
   var totalSecond = 60
    var timer = Timer()
    
    @IBOutlet weak var lbltime: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnresendotp.isUserInteractionEnabled = false
        btnresend.isUserInteractionEnabled = false
        lbltime.isHidden = true
        lblmain.text = "Transfer By Raast ID".addLocalizableString(languageCode: languageCode)
        lblSubTitle.text = "Enter OTP".addLocalizableString(languageCode: languageCode)
        lblenterotpdetail.text = "Enter the code sent on your mobile device manually".addLocalizableString(languageCode: languageCode)
        btnresendotp.setTitle("Resend OTP".addLocalizableString(languageCode: languageCode), for: .normal)
        btnsubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnresendotp.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnresendotp.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        btnresend.setTitle("Resend OTP".addLocalizableString(languageCode: languageCode), for: .normal)
        opttextfield.delegate = self
        print("uniquekey IS", uniquekey)
        startTimer()
//        btnresendotp.isUserInteractionEnabled = false
        getcnic()
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBOutlet weak var btnresend: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblmain: UILabel!
   
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var lblenterotpdetail: UILabel!
    
    
    @IBOutlet weak var opttextfield: UITextField!
    
    
    @IBOutlet weak var btnsubmit: UIButton!
    
    
    @IBOutlet weak var btnresendotp: UIButton!
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func resendotp(_ sender: UIButton) {
//
        ResendOTp()
      
        lbltime.isHidden = false
//        startTimerSecondTime()
    }
    
  
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submit(_ sender: UIButton) {
        if opttextfield.text?.count != 0{
            FundTransferapi()
            endTimer()
            
        }
        
        else
        {
            showToast(title: "Enter  Valid OTP")
        }
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func resenotpviacall(_ sender: UIButton) {
        OTVCall()
        
    }
    
    func startTimer() {
        totalSecond = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.countDownLabel.text = "\(self.timeFormatted(self.totalSecond))s"
        print(timeFormatted(totalSecond))
        
        if totalSecond < 1 {
            endTimer()
            
        } else {
            totalSecond -= 1
            
        }
    }
    
    func endTimer() {
//
       
        btnresendotp.isUserInteractionEnabled = true
        btnresend.isUserInteractionEnabled = true

//        btnsubmit.isUserInteractionEnabled = false
//        btnresendotp.isUserInteractionEnabled = true
        timer.invalidate()
       
//
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "0:%02d", seconds)
    }
    
//    second call timer
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == opttextfield
        { opttextfield.isUserInteractionEnabled = true
            return newLength <= 6
        }
       
        return newLength <= 6
    }
    
    private func OTVCall() {
        startTimer()
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/OTV/TRX"
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        AF.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genRespBaseObj = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.genRespBaseObj?.response == 2 || self.genRespBaseObj?.response == 1 {
                        
                        self.showDefaultAlert(title: "", message: self.genRespBaseObj!.message!)
                    }
                    else {
                        if let message = self.genRespBaseObj?.message {
                            if let message = self.genRespBaseObj?.message{
                                self.showAlert(title: "", message: message, completion: {
                                    
                                    //                                   self.navigationController?.popToRootViewController(animated: true)
                                })
                            }
                        }
                        
                        else {
                            if let message = self.genRespBaseObj?.message {
                                self.showAlert(title: "", message: message, completion: {
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                            }
                            //                print(response.result.value)
                            //                print(response.response?.statusCode)
                            
                        }
                    }
                }
            }
        }
    }
    private func ResendOTp() {
        startTimer()
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/OTP/TRX"
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        //
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genRespBaseObj = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.genRespBaseObj?.response == 2 || self.genRespBaseObj?.response == 1 {
                        //                       self.startTimerSecondTime()
                        //
                        self.showDefaultAlert(title: "", message: self.genRespBaseObj!.message!)
                    }
                    else {
                        if let message = self.genRespBaseObj?.message {
                            if let message = self.genRespBaseObj?.message{
                                self.showAlert(title: "", message: message, completion: {
                                    
                                    //                                   self.navigationController?.popToRootViewController(animated: true)
                                })
                            }
                        }
                        else {
                            if let message = self.genRespBaseObj?.message {
                                self.showAlert(title: "", message: message, completion: {
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                            }
                            //                print(response.result.value)
                            //                print(response.response?.statusCode)
                        }
                    }
                }
            }
        }
    }
    
    var userCnic : String?
    func getcnic()
    {
      
    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
    }
    else{
        userCnic = ""
    }
    
    }
        
        
    private func FundTransferapi(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
//        "Content-Type":"application/x-www-form-urlencoded"
        showActivityIndicator()
//        http://mobappuat.fmfb.pk/
//        let compelteUrl = "http://app.fmfb.com.pk/api/v1/Customers/Sparrow/FundsTransfer"
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/FundsTransfer"
        let header:HTTPHeaders =
        ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
//,"account_imd": "P2P"
        let params = ["lat" : DataManager.instance.Latitude!, "lng": DataManager.instance.Longitude! , "imei": DataManager.instance.imei!  ,"to_account_iban": (bebeiban! ?? ""), "to_account_title": (beneficaryAccount! ?? ""),"to_mmbid": (mid! ?? ""),"amount": (transferAmount! ?? ""), "transaction_reason": (PurpseReasonId! ?? ""),"to_mobile" : (benealias! ?? ""),"otp": (opttextfield.text!),"account_imd": "P2P"] as [String : Any]

        print(compelteUrl)
        print(params)
        print(DataManager.instance.stringHeader!)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<FundTransfer>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<FundTransfer>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.FundTransferobj = Mapper<FundTransfer>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.FundTransferobj?.response == 2 || self.FundTransferobj?.response == 1 {
                        self.startTimer()
                        if let message = self.FundTransferobj?.message {
                            //                        if let message = self.FundTransferobj?.message{
                            //                        self.showAlert(title: "", message: message, completion: {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"TransactionAliasSuccessfull") as! TransactionAliasSuccessfull
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            //                        })
                            //                    }
                        }
                    }
                    else {
                        if let message = self.FundTransferobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                //                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"TransferByAliasVC") as! TransferByAliasVC
                                //
                                //                        self.navigationController?.pushViewController(vc, animated: true)
                                //                        self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.FundTransferobj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        }
                        else{
                            self.showAlert(title: "", message: message, completion: {
                                //                    self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
                    }
                    //
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }

    private func TitleFetchAlias(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/TitleFetch"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        //
        //        let params = ["lat" : DataManager.instance.Latitude! , "lng": DataManager.instance.Longitude! , "imei": DataManager.instance.imei! ,"cnic": , "account_number": DataManager.instance.accountno ?? "" ,"alias_type": (selectedlist! ?? ""),"alias_value": (mobilenoTextfield.text! ?? "")] as [String : Any]
        
        let params = ["lat" : DataManager.instance.Latitude! , "lng": DataManager.instance.Longitude! , "imei": DataManager.instance.imei! ,"cnic":userCnic! ?? "", "account_number": DataManager.instance.accountno ?? "" ,"alias_type": ( "MOBILE"),"alias_value": (mobiletextfiledvalue! ?? "")] as [String : Any]
        //
        print(compelteUrl)
        //
        print(params)
        print(DataManager.instance.stringHeader!)
        //
        //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<WHTCalculations>) in
        //
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<TransationByAliasModel>) in
            
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<TransationByAliasModel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.TransationByAliasModelobj = Mapper<TransationByAliasModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.TransationByAliasModelobj?.response == 2 {
                        if let message = self.TransationByAliasModelobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                //                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaastSubvIew2Vc") as!  RaastSubvIew2Vc
                                //
                                //                             self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                    }
                    
                    if self.TransationByAliasModelobj?.response == 1 {
                        
                    }
                    else {
                        if let message = self.TransationByAliasModelobj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.TransationByAliasModelobj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        }
                        else{
                            self.showAlert(title: "", message: message, completion: {
                                //                    self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        }
                    }
                    
                    //                if let message = self.TransationByAliasModelobj?.message{
                    //                    self.showDefaultAlert(title: "", message: message)
                    //                }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
    
    
    

