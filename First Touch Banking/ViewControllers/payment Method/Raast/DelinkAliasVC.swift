//
//  DelinkAliasVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 31/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import iOSDropDown
import SkyFloatingLabelTextField
import ObjectMapper
class DelinkAliasVC: BaseVC {
    var getAlaisvalue = ""
    var getAliasType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Delink RAAST ID".addLocalizableString(languageCode: languageCode)
        lblsubtitle.text = "Confirm following details to delink your Raast ID".addLocalizableString(languageCode: languageCode)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnconfirm.setTitle("CONFIRM".addLocalizableString(languageCode: languageCode), for: .normal)
        
        CheckDetails()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBOutlet weak var btnconfirm: UIButton!
    var checkDetailsUserobj : CustomerDetail?
    @IBOutlet weak var lblAccNo: UILabel!
    
    @IBOutlet weak var lblsubtitle: UILabel!
    @IBOutlet weak var lblIBan: UILabel!
    @IBOutlet weak var lblCnic: UILabel!
    @IBOutlet weak var lblAlias: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "RegisterAliasSuccessVC") as!
        RegisterAliasSuccessVC
        vc.isFromDelinkalias = true
        vc.Delinkaliasvalue = getAlaisvalue
        vc.Delinkaliastype = getAliasType
        
        self.navigationController?.pushViewController(vc, animated: true)
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
                        var a = (self.checkDetailsUserobj?.dataCustomerDetail?.customer_mobile! ?? "")
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
                        let c = final.replacingOccurrences(of: final, with: "xxxxxxx")
                        let v = aa +  c
                        print("v", v)
                        
                        self.lblAlias.text = "Alias: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_mobile!  ?? "")"
                        self.lblCnic.text = "CNIC: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_cnic! ?? "")"
                        self.lblAccNo.text = "Account: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_account_no! ?? "")"
                        self.lblIBan.text = "IBAN: \(self.checkDetailsUserobj?.dataCustomerDetail?.customer_account_iban! ?? "")"
                        self.getAlaisvalue = self.checkDetailsUserobj?.dataCustomerDetail?.alias_value! ?? ""
                        print("getfromapi alaisvalue",self.checkDetailsUserobj?.dataCustomerDetail?.alias_value! ?? "")
                        self.getAliasType = self.checkDetailsUserobj?.dataCustomerDetail?.alias_type! ?? ""
                        print("getfromapialiastype alaistype",self.checkDetailsUserobj?.dataCustomerDetail?.alias_type! ?? "")
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
}
