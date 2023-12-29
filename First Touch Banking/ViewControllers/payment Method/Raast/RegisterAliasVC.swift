//
//  RegisterAliasVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 30/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import iOSDropDown
import SkyFloatingLabelTextField
import SwiftKeychainWrapper
import ObjectMapper
var IsAliasAlreadyReg : String?
var checkalias : String?
class RegisterAliasVC: BaseVC, UITextFieldDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
//     if IsAliasAlreadyReg == checkalias
//        {
////         showAlert(title: "", message: "Alias Already Registered") {
////             self.navigationController?.popViewController(animated: true)
//         }
//     }
//        else
//        {
        methodDropDownInquiries()
        CheckDetails()
        getAccounts()
        mobiletextfield.delegate = self
        mobiletextfield.placeholder = "Select Type".addLocalizableString(languageCode: languageCode)
        lblmaintitle.text = "Register RAAST ID".addLocalizableString(languageCode: languageCode)
        lblChooseAccount.text = "Choose Account".addLocalizableString(languageCode: languageCode)
        lblSubTitle.text = "Do you want to Register your Raast ID with Follwing Detail".addLocalizableString(languageCode: languageCode)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        
        btnConfirm.setTitle("CONFIRM".addLocalizableString(languageCode: languageCode), for: .normal)
       
//        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblChooseAccount: UILabel!
    @IBOutlet weak var lblmaintitle: UILabel!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var lblIBan: UILabel!
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var lblCNic: UILabel!
    @IBOutlet weak var lblalias: UILabel!
    @IBOutlet weak var mobiletextfield: DropDown!
    var accountsObj:Accounts?
    var sourceAccount:String?
    var selectedlist : String?
    var aliasValue : String?
    var arrAccountList : [String]?
    var CustomerDetailobj : sparrowindexmodel?

    
    @IBOutlet weak var dropDownAccounts: DropDown!
    
    
    @IBAction func back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnconfirm(_ sender: UIButton) {
        if dropDownAccounts.text?.count == 0
        {
            self.showToast(title: "Please Select Account")
            return
        }
        if mobiletextfield.text?.count == 0
        {
            self.showToast(title: "Please Select Alias Type")
            return
        }
        
        else{
           let vc  = self.storyboard?.instantiateViewController(withIdentifier: "RegisterAliasSuccessVC") as!
           RegisterAliasSuccessVC
            vc.isFromRegisteralias = true
           vc.aliastype = selectedlist
           vc.aliasvalue = aliasValue
           self.navigationController?.pushViewController(vc, animated: true)
       
        }
        
    
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    private func methodDropDownAccounts(Accounts:[String]) {
        
        self.dropDownAccounts.placeholder = Accounts[0]
        self.dropDownAccounts.rowHeight = 80.0
        self.dropDownAccounts.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.sourceAccount = Accounts[0]
        self.dropDownAccounts.optionArray = Accounts
        self.dropDownAccounts.didSelect{(b , index ,id) in
            print("You Just select: \(b) at index: \(index)")
            self.sourceAccount = b
           
        }
    }
    
    
    private func methodDropDownInquiries() {
          
//        self.mobiletextfield.placeholder = "Select".addLocalizableString(languageCode: languageCode)
        self.mobiletextfield.selectedRowColor = UIColor.gray
            self.mobiletextfield.optionArray = ["RAAST ID"]
            self.mobiletextfield.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.mobiletextfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.mobiletextfield.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.mobiletextfield.didSelect{(b , index ,id) in
            self.selectedlist = b
            self.selectmobile()
            self.mobiletextfield.selectedRowColor = UIColor.gray
            self.mobiletextfield.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.mobiletextfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.mobiletextfield.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           
             
    }
               
    }
    func selectmobile()
    {
        if self.selectedlist == "RAAST ID"
            
        {
            selectedlist = "MOBILE"
            self.aliasValue =  (self.CustomerDetailobj?.datasparow?.customer_mobile! ?? "")
            self.lblalias.textColor = UIColor.blue
            self.lblCNic.textColor = UIColor.black
            
        }
//        if self.selectedlist == "CNIC"
//        {
//            self.aliasValue =   (self.CustomerDetailobj?.datasparow?.customer_cnic! ?? "")
//            self.lblalias.textColor = UIColor.black
//            self.lblCNic.textColor = UIColor.blue
//        }
    }
    
    private func getAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
//            Object { (response: DataResponse<Accounts>) in
        
//        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<Accounts>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.accountsObj = Mapper<Accounts>().map(JSONObject: json)
                    
                    if self.accountsObj?.response == 2 || self.accountsObj?.response == 1 {
                        self.methodDropDownInquiries()
                        
                        self.arrAccountList = self.accountsObj?.stringAccounts
                        //                    self.currentID = self.issueListObj?.issuesList?[0].id
                        self.methodDropDownAccounts(Accounts: (self.arrAccountList)!)
                        
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
   
    
//    get customerdeatil
    
    private func CheckDetails(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
//        Constants.BASE_URL
        let compelteUrl =  Constants.BASE_URL +  "api/v1/Customers/Sparrow"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)

//        NetworkManager.sharedInstance.enableCertificatePinning()
//               NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<sparrowindexmodel>) in
//       //        thekkrna h
        AF.request(compelteUrl, headers:header).response { response in
            //            Object { (response: DataResponse<sparrowindexmodel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.CustomerDetailobj = Mapper<sparrowindexmodel>().map(JSONObject: json)
                    if self.CustomerDetailobj?.response == 2 || self.CustomerDetailobj?.response == 1 {
                        DataManager.instance.AliasType = self.selectedlist
                        //                    var a = (self.CustomerDetailobj?.datasparow?.customer_mobile! ?? "")
                        let largeNumber = (self.CustomerDetailobj?.datasparow?.customer_mobile! ?? "")
                        
                        var a = (self.CustomerDetailobj?.datasparow?.customer_mobile! ?? "")
                        let b = a.split(by: 4)
                        print("b ", b)
                        var aa = b[0]
                        var x = b[1]
                        var y = b[2]
                        //                    let c = aa.removeFirst()
                        //                    aa.removeFirst()
                        //                    aa.removeFirst()
                        //                    aa.removeFirst()
                        //                    print("c",c)
                        let final = x + y
                        let v = aa + "_" + final
                        print("v", v)
                        DataManager.instance.AliasValue = self.CustomerDetailobj?.datasparow?.customer_mobile! ?? ""
                        
                        self.lblalias.text = "RAAST ID: \(self.CustomerDetailobj?.datasparow?.customer_mobile! ?? "")"
                        self.lblCNic.text = "CNIC: \(self.CustomerDetailobj?.datasparow?.customer_cnic! ?? "")"
                        self.lblAccNo.text = "Account: \(self.CustomerDetailobj?.datasparow?.customer_account_no! ?? "")"
                        self.lblIBan.text = "IBAN: \(self.CustomerDetailobj?.datasparow?.customer_account_iban! ?? "")"
                        
                        //                    if let message = self.CheckLeafObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
                    }
                    else {
                        if let message = self.CustomerDetailobj?.message{
                            
                            self.showDefaultAlert(title: "", message: message)
                            
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
                else {
                    if let message = self.CustomerDetailobj?.message{
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
                    //                if let message = self.CustomerDetailobj?.message{
                    //                   self.showAlert(title: "", message: message, completion: {
                    //                    self.navigationController?.popToRootViewController(animated: true)
                    //                })
                    
                    
                    
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}

    
