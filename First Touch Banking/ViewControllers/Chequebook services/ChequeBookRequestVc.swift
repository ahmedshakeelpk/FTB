//
//  ChequeBookRequestVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
//import AlamofireObjectMapper
import SkyFloatingLabelTextField
import ObjectMapper
class ChequeBookRequestVc: BaseVC {
    var genericResponse:GenericResponse?
    var genericObj: GenericResponse?
    var selectedlist : String?
    var SelectLocation : String?
    var selectlist : String?
    var selectLOV  :String?
    
    @IBOutlet weak var LOvLocation: DropDown!
    @IBOutlet weak var lblLocation: UILabel!
    var array = ["25","50","100"]
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "ChequeBook Request".addLocalizableString(languageCode: languageCode)
        lblSelectCheckBook.text = "Select ChequeBook".addLocalizableString(languageCode: languageCode)
        lblLocation.text = "Select Mode of Delivery".addLocalizableString(languageCode: languageCode)
        btnApply.setTitle("APPLY".addLocalizableString(languageCode: languageCode), for: .normal)
        self.methodDropDownInquiries()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblMain: UILabel!
    @IBAction func CheckBookListDRopdown(_ sender: DropDown) {
        //        SelectCBdropdown.optionArray = ["25","50","100"]
        //        self.SelectCBdropdown.isSelected = true
        //        self.SelectCBdropdown.selectedRowColor = UIColor.gray
        //        self.SelectCBdropdown.isSearchEnable = true
        //        self.SelectCBdropdown.optionArray =  self.array
        //        selectLOV = self.SelectCBdropdown.text
    }
    
    @IBAction override func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var lblSelectCheckBook: UILabel!
    @IBOutlet weak var SelectCBdropdown: DropDown!
    @IBOutlet weak var btnApply: UIButton!
    
    @IBAction func apply(_ sender: UIButton) {
        if SelectCBdropdown.text?.count == 0
        {
            showToast(title: "Please Select ChequeBook")
        }
        else if LOvLocation.text?.count == 0
        {
            showToast(title: "Please Select Loaction")
        }
        else{
            self.ChequeBookRequestOTP()
        }
    }
    
    private func methodDropDownInquiries() {
        
        self.SelectCBdropdown.placeholder = "Select".addLocalizableString(languageCode: languageCode)
        self.SelectCBdropdown.selectedRowColor = UIColor.gray
        self.SelectCBdropdown.optionArray = ["10","25","50","100"]
        self.SelectCBdropdown.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.SelectCBdropdown.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.SelectCBdropdown.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.SelectCBdropdown.didSelect{(b , index ,id) in
            self.SelectCBdropdown.selectedRowColor = UIColor.gray
            self.SelectCBdropdown.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
            self.SelectCBdropdown.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.SelectCBdropdown.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.selectedlist = b
            DataManager.instance.ChequeLocation = b
            self.methodDropDownLocation()
        }
    }
    
    private func methodDropDownLocation() {
        
        self.LOvLocation.placeholder = "Select".addLocalizableString(languageCode: languageCode)
        self.LOvLocation.selectedRowColor = UIColor.gray
        self.LOvLocation.optionArray = ["Correspondence Address","Branch Address"]
        self.LOvLocation.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.LOvLocation.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.LOvLocation.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.LOvLocation.didSelect{(b , index ,id) in
            self.LOvLocation.selectedRowColor = UIColor.gray
            self.LOvLocation.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
            self.LOvLocation.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.LOvLocation.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            self.SelectLocation = b
            if self.SelectLocation == "Correspondence Address"
            {
                self.SelectLocation = "homeadd"
            }
            else{
                self.SelectLocation = "branchadd"
            }
            print("location", self.SelectLocation)
        }
    }
    
    private func ChequeBookRequestOTP() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/ChequeBookRequest/OTP"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                    //                self.genericResponse = response.result.value
                    if self.genericResponse?.response == 1 {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                        vc.SelectChecqueType = self.SelectCBdropdown.text
                        vc.SelectedLocation = self.SelectLocation
                        print("Selected Location is ", self.SelectLocation)
                        IsFromChequeBookRequest = "true"
                        isFromStopPyemnt = "false"
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        if let messageErrorTrans = self.genericResponse?.message{
                            self.showDefaultAlert(title: "", message: messageErrorTrans)
                        }
                    }
                }
                else {
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                    
                    if let messageErrorTrans = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: messageErrorTrans)
                    }
                }
            }
        }
    }
}
