//
//  SelectLimitMangamnetLovVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 03/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper
var MBidget : String?
var ATMIdget : String?
class SelectLimitMangamnetLovVC: BaseVC {
    
    var IsFromATM  = ""
    var IsFromMb = ""
    var maximumAllowedLimitATM : String?
    var maximumAllowedLimitMB : String?
    var GenericOBj :GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Account Limit Management".addLocalizableString(languageCode: languageCode)
        lblSelectAccountLimit.text = "Enter Account Limit".addLocalizableString(languageCode: languageCode)
        btnChangeLimit.setTitle("Change Limit".addLocalizableString(languageCode: languageCode), for: .normal)
        
        if IsFromMb == "true" {
            dropdownLimit.placeholder = "Enter Amount Between 1 to \(maximumAllowedLimitMB!)"
        }
        else{
            dropdownLimit.placeholder = "Enter Amount Between 1 to \(maximumAllowedLimitATM!)"
        }
    }
    
    @IBOutlet weak var lblSelectAccountLimit: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var dropdownLimit: UITextField!
    @IBOutlet weak var btnChangeLimit: UIButton!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeLimit(_ sender: UIButton) {
        if dropdownLimit.text?.count == 0{
            showToast(title: "Please Enter Account Limit")
        }
        else
        {
            if IsFromMb == "true"
            {
                setAccountLimitsOTP()
            }
            else{
                setAccountLimitsOTP()
            }
        }
    }
    
    private func setAccountLimitsOTP(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/setLimit/OTP"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get,  encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.GenericOBj = Mapper<GenericResponse>().map(JSONObject: json)
                //            self.GenericOBj = response.result.value
                if response.response?.statusCode == 200 {
                    if self.GenericOBj?.response == 2 || self.GenericOBj?.response == 1 {
                        if self.IsFromMb == "true" {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                            //                       ATMIdget = self.ATMIdget
                            customer_account_limit = self.dropdownLimit.text
                            isFromStopPyemnt = "false"
                            IsFromAccountLimitMb = "true"
                            IsFromChequeBookRequest = "false"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                            isFromStopPyemnt = "false"
                            //                       MBidget = self.MBidget
                            IsFromAccountLimitATM = "true"
                            customer_account_limit = self.dropdownLimit.text
                            IsFromChequeBookRequest = "false"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else {
                        if let message = self.GenericOBj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.GenericOBj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
