//
//  RegisterAliasSuccessVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 30/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper
var alaistyperelink = ""
var alaisvalauerelink = ""
class RegisterAliasSuccessVC: BaseVC , UITextFieldDelegate{
    var checkDetailsUserobj : CustomerDetail?
    var isFromRegisteralias:Bool = false
    var isFromDelinkalias:Bool = false
    var aliastype : String?
    var aliasvalue : String?
    var Delinkaliastype : String?
    var Delinkaliasvalue : String?
    var Delinkobj : DelinkModel?
    var relinkobj : Relinkailas?
    
    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        
        passwordtextfield.delegate = self
        if isFromRegisteralias == true
        {
            lblmain.text = "Register RAAST ID".addLocalizableString(languageCode: languageCode)
            lbldetail.text = "you've choosen your registered mobile as your Raast ID.Once you've registerd , people can send  funds to you ".addLocalizableString(languageCode: languageCode)
        }
        if isFromDelinkalias == true
        {
            lblmain.text = "Delink RAAST ID".addLocalizableString(languageCode: languageCode)
            lbldetail.text = "You are going to delink your alias from your bank account.Once you delinked, people can't send funfds to you using your alias.".addLocalizableString(languageCode: languageCode)
        }
        if isFromRelink == "true"
        {
            lblmain.text = "Relink RAAST ID".addLocalizableString(languageCode: languageCode)
            lbldetail.text = "You have chosen your registered mobile number as your Raast ID. Once you have relink, people can send funds to you using your Raast ID.".addLocalizableString(languageCode: languageCode)
        }
        
        
        
        print("aliasvalue " , aliasvalue)
        print("alaistype " , aliastype)
        lblverify.text = "Verify thats it's you!".addLocalizableString(languageCode: languageCode)
        lblenterpassword.text = "Enter your Password".addLocalizableString(languageCode: languageCode)
        
        btnproceed.setTitle("Proceed".addLocalizableString(languageCode: languageCode), for: .normal)
        //        passwordtextfield.placeholder = "Enter 6 Digit password".addLocalizableString(languageCode: languageCode)
        
    }
    var SparrowRegisterModelobj : SparrowRegisterModel?
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var lblverify: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var btnproceed: UIButton!
    @IBOutlet weak var lbldetail: UILabel!
    @IBOutlet weak var lblenterpassword: UILabel!
    @IBOutlet weak var backpressed: UIButton!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func proceed(_ sender: UIButton) {
        
        
        if passwordtextfield.text?.count == 0 {
            showToast(title: "Please enter 6 digit password")
        }
        else
        {
            if isFromRegisteralias == true
            {
                SparrowRegister()
            }
            if isFromDelinkalias == true
            {
                DelinkAccount()
                
            }
            if isFromRelink == "true"
            {
                //                  self.Relinlailas()
                CheckDetails()
                
            }
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == passwordtextfield
        {
            passwordtextfield.isUserInteractionEnabled = true
            return newLength <= 6
            
        }
        return newLength <= 6
    }
    
    private func SparrowRegister(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl =  Constants.BASE_URL + "api/v1/Customers/Sparrow/Register"
        
        
        let params = ["alias_type": (aliastype! ?? ""), "alias_value": (aliasvalue! ?? ""),"password": passwordtextfield.text!]
        
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type": "application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<SparrowRegisterModel>) in
            //      Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<SparrowRegisterModel>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.SparrowRegisterModelobj = Mapper<SparrowRegisterModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.SparrowRegisterModelobj?.response == 2 || self.SparrowRegisterModelobj?.response == 1 {
                        if let message = self.SparrowRegisterModelobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as!  HomeVC
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                    }
                    else {
                        if let message = self.SparrowRegisterModelobj?.message{
                            
                            self.showAlert(title: "", message: message, completion: {
                                //                         self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.SparrowRegisterModelobj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        }
                        else{
                            
                        }
                        self.showAlert(title: "", message: message, completion: {
                            //                    self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    //             if let message = self.SparrowRegisterModelobj?.message{
                    //                 self.showAlert(title: "", message: message, completion: {
                    //                     self.navigationController?.popToRootViewController(animated: true)
                    //                 })
                    //             }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func DelinkAccount(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl =  Constants.BASE_URL + "api/v1/Customers/Sparrow/DelinkSparrow"
        
        //
        //        let params = ["alias_type": (DataManager.instance.AliasType ?? ""), "alias_value": (DataManager.instance.AliasType ?? ""),"password": passwordtextfield.text!]
        
        
        let params = ["alias_type": (Delinkaliastype! ?? ""), "alias_value":  (Delinkaliasvalue! ?? "") ,"password": passwordtextfield.text!]
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type": "application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<DelinkModel>) in
            //      Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<DelinkModel>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.Delinkobj = Mapper<DelinkModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.Delinkobj?.response == 2 {
                        let consentAlert = UIAlertController(title: self.Delinkobj?.message, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        
                        consentAlert.addAction(UIAlertAction(title: "OK".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"HomeVC") as! HomeVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }))
                        
                        
                        
                    }
                    if  self.Delinkobj?.response == 1 {
                        
                        if let message = self.Delinkobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaastSubvIew2Vc") as!  RaastSubvIew2Vc
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                        
                    }
                    else {
                        if let message = self.Delinkobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                //                     self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
                    }
                }
                else {
                    if let message = self.Delinkobj?.message{
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
                    //             if let message = self.Delinkobj?.message{
                    //             self.showAlert(title: "", message: message, completion: {
                    //                 self.navigationController?.popToRootViewController(animated: true)
                    //             })
                    //         }
                    
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func CheckDetails(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        //        Constants.BASE_URL
        let compelteUrl =  Constants.BASE_URL +  "api/v1/Customers/Sparrow/CheckDetails"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        //
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<CustomerDetail>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CustomerDetail>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.checkDetailsUserobj = Mapper<CustomerDetail>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.checkDetailsUserobj?.response == 2 || self.checkDetailsUserobj?.response == 1 {
                        
                        alaistyperelink = self.checkDetailsUserobj?.dataCustomerDetail?.alias_type ?? ""
                        alaisvalauerelink = self.checkDetailsUserobj?.dataCustomerDetail?.alias_value ?? ""
                        self.Relinlailas()
                        //                    self.lblAlias.text = "Alias: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_mobile!  ?? "")"
                        //                    self.lblCnic.text = "CNIC: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_cnic! ?? "")"
                        //                    self.lblAccNo.text = "Account: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_account_no! ?? "")"
                        //                    self.lblIBan.text = "IBAN: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_account_iban! ?? "")"
                        //                    self.getAlaisvalue = self.checkDetailsUserobj?.dataCustomerDetail?.alias_value! ?? ""
                        //                    print("getfromapi alaisvalue",self.checkDetailsUserobj?.dataCustomerDetail?.alias_value! ?? "")
                        //                    self.getAliasType = self.checkDetailsUserobj?.dataCustomerDetail?.alias_type! ?? ""
                        //                    print("getfromapialiastype alaistype",self.checkDetailsUserobj?.dataCustomerDetail?.alias_type! ?? "")
                        //                    if let message = self.CheckLeafObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
                    }
                    else {
                        if let message = self.checkDetailsUserobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaastSubvIew2Vc") as! RaastSubvIew2Vc
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.checkDetailsUserobj?.message{
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
                    //                if let message = self.checkDetailsUserobj?.message{
                    //                self.showAlert(title: "", message: message, completion: {
                    //                    self.navigationController?.popToRootViewController(animated: true)
                    //                })
                    //            }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func Relinlailas(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl =  Constants.BASE_URL + "api/v1/Customers/Sparrow/RelinkSparrow"
        
        print("aliastype", alaistyperelink)
        let params = ["alias_type": (alaistyperelink), "alias_value": (alaisvalauerelink),"password": passwordtextfield.text!]
        
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type": "application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Relinkailas>) in
            //      Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Relinkailas>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.relinkobj = Mapper<Relinkailas>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.relinkobj?.response == 2{
                        if let message = self.relinkobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaastSubvIew2Vc") as!  RaastSubvIew2Vc
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                    }
                    if self.relinkobj?.response == 0{
                        if let message = self.relinkobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaastSubvIew2Vc") as!  RaastSubvIew2Vc
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                        
                    }
                    if self.relinkobj?.response == 1 {
                        if let message = self.relinkobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as!  HomeVC
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                        
                    }
                    else {
                        if let message = self.relinkobj?.message{
                            
                            self.showAlert(title: "", message: message, completion: {
                                //                         self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.relinkobj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        }
                        else{
                            
                        }
                        self.showAlert(title: "", message: message, completion: {
                            //                    self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
