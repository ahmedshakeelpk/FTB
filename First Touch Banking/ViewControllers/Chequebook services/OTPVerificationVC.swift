//
//  OTPVerificationVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 02/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper
var isFromStopPyemnt = ""
var IsFromChequeBookRequest = ""
var IsFromAccountLimitATM = ""
var IsFromAccountLimitMb = ""
var customer_account_limit :String?
class OTPVerificationVC: BaseVC, UITextFieldDelegate {
    var genericResponse:GenericResponse?
    var CheckLeafObj : LeafInq?
    var SelectChecqueTyp : String?
    var from_leaf : String?
    var to_laf : String?
    var stop_payment_reason : String?
    var SelectChecqueType : String?
    var SelectedLocation : String?
    var totalSecond = 60
    var timer = Timer()
    @IBOutlet weak var lblCount: UILabel!
    //    var ATMIdget : String?
    //    var MBidget : String?
    var StopPaymentObj : StopPayment?
    
    var newreqOBj : NewRequest?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnresendotp.isUserInteractionEnabled = false
        startTimer()
        lblMain.text = "VERIFY OTP".addLocalizableString(languageCode: languageCode)
        lblSubTitle.text = "OTP VERIFICATION".addLocalizableString(languageCode: languageCode)
        lblOTPDetail.text = "Please Enter the OTP sent to your Mobile Number".addLocalizableString(languageCode: languageCode)
        btnresendotp.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        btnNext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
        print("ATm Limit id is", ATMIdget)
        print("MB limit id si ", MBidget)
        enterotptxtfield.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblOTPDetail: UILabel!
    @IBOutlet weak var btnresendotp: UIButton!
    @IBOutlet weak var enterotptxtfield: UITextField!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func startTimer() {
        totalSecond = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.lblCount.text = "\(self.timeFormatted(self.totalSecond))s"
        print(timeFormatted(totalSecond))
        
        if totalSecond < 1 {
            endTimer()
            
        } else {
            totalSecond -= 1
        }
    }
    
    func endTimer() {
        
        btnresendotp.isUserInteractionEnabled = true
        timer.invalidate()
        
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "0:%02d", seconds)
    }
    @IBAction func Next(_ sender: UIButton) {
        
        if enterotptxtfield.text?.count == 0
        {
            showToast(title: "Please Enter OTP")
        }
        else{
            
            if  IsFromChequeBookRequest == "true" &&  isFromStopPyemnt == "false"
            {
                ChequeNewRequest()
            }
            
            else if IsFromChequeBookRequest == "false" &&  isFromStopPyemnt == "true"{
                StopPayment()
            }
            else{
                if IsFromAccountLimitATM == "true"
                {
                    setAccountLimitsATM()
                    
                }
                else{
                    setAccountLimitsMB()
                }
            }
        }
    }
    
    @IBAction func ResendOTP(_ sender: UIButton) {
        if IsFromChequeBookRequest == "true" &&  isFromStopPyemnt == "false"
        {
            self.ChequeBookRequestOTV()
        }
        else if IsFromChequeBookRequest == "false" &&  isFromStopPyemnt == "true" {
            StopChequePaymentOTV()
        }
        else{
            setLimitOTV()
        }
    }
    
    
    private func ChequeBookRequestOTV() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/ChequeBookRequest/OTV"
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
                self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    //                self.genericResponse = response.result.value
                    if self.genericResponse?.response == 1 {
                        
                    }
                    else {
                        if let messageErrorTrans = self.genericResponse?.message{
                            self.showDefaultAlert(title: "", message: messageErrorTrans)
                        }
                    }
                }
                else {
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                    if let messageErrorTrans = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: messageErrorTrans)
                    }
                }
            }
        }
    }
    private func setLimitOTV() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/setLimit/OTV"
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
                        
                    }
                    else {
                        if let messageErrorTrans = self.genericResponse?.message{
                            self.showDefaultAlert(title: "", message: messageErrorTrans)
                        }
                    }
                }
                else {
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                    if let messageErrorTrans = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: messageErrorTrans)
                    }
                }
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == enterotptxtfield{
            return newLength <= 4
        }
        
        else {
            return newLength <= 4
        }
    }
    
    
    //    MARK: OTV
    private func StopChequePaymentOTV() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/StopChequePayment/OTV"
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
                    
                    //                    self.genericResponse = response.result.value
                    if self.genericResponse?.response == 1 {
                        
                    }
                    else {
                        if let messageErrorTrans = self.genericResponse?.message{
                            self.showDefaultAlert(title: "", message: messageErrorTrans)
                        }
                    }
                }
                else {
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                    if let messageErrorTrans = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: messageErrorTrans)
                    }
                }
            }
        }
    }
    private func ChequeNewRequest(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/ChequeBookRequest"
        let params = ["no_of_leavs": SelectChecqueType!,"otp": enterotptxtfield.text!, "delivery_location":SelectedLocation!]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        
        //        "Content-Type":"application/x-www-form-urlencoded"
        //        "Authorization":"Bearer \(DataManager.instance.accessToken!),"Content-Type":"application/x-www-form-urlencoded""
        
        
        
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<NewRequest>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<NewRequest>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.newreqOBj = Mapper<NewRequest>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    //            self.newreqOBj = response.result.value
                    if self.newreqOBj?.response == 2 || self.newreqOBj?.response == 1 {
                        self.startTimer()
                        if let message = self.newreqOBj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    
                    else {
                        if let message = self.newreqOBj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.newreqOBj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    
    private func StopPayment(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/StopPayment"
        
        let params = ["from_leaf": from_leaf!, "to_laf": self.to_laf!, "stop_payment_reason": stop_payment_reason!, "otp": enterotptxtfield.text!]
        //
        let header: HTTPHeaders = ["Accept":"application/json" ,"Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<StopPayment>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<StopPayment>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.StopPaymentObj = Mapper<StopPayment>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.StopPaymentObj?.response == 2 || self.StopPaymentObj?.response == 1 {
                        self.startTimer()
                        if let message = self.StopPaymentObj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    else {
                        if let message = self.StopPaymentObj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.StopPaymentObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
            
        }
    }
    private func setAccountLimitsATM(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/setAccountLimits"
        
        let params = ["lat": DataManager.instance.Latitude!, "lng": DataManager.instance.Longitude!, "imei": DataManager.instance.imei!, "otp": enterotptxtfield.text! ,"limitID": ATMIdget ?? "","key":  DataManager.instance.keyATm!,"frequency": DataManager.instance.frequencyATM!,"identifier":    DataManager.instance.identifierATm!,"customer_account_limit": customer_account_limit! ] as [String : Any]
        //
        let header: HTTPHeaders = ["Accept":"application/json" ,"Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.genericResponse?.response == 2 || self.genericResponse?.response == 1 {
                        self.startTimer()
//                        if let message = self.genericResponse?.message{
//                            self.showAlert(title: "", message: message, completion: {
//                                self.navigationController?.popToRootViewController(animated: true)
//                            })
//                        }
                        if let message = self.genericResponse?.message{
                            self.showAlert(title: "", message: message, completion: {
                                //                            self.navigationController?.popToRootViewController(animated: true)
                                //                           circluar 4 changes
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC")
                                as! RegistrationVC
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                            })
                            //                        self.showAlert(title: "", message: message, completion: {
                            //                            self.navigationController?.popToRootViewController(animated: true)
                            //                        })
                        }
                    }
                    else {
                        if let message = self.genericResponse?.message{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: message)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    private func setAccountLimitsMB(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/setAccountLimits"
        
        let params = ["lat": DataManager.instance.Latitude!, "lng": DataManager.instance.Longitude!, "imei": DataManager.instance.imei!, "otp": enterotptxtfield.text! ,"limitID": MBidget ?? "","key": DataManager.instance.keyMB!,"frequency": DataManager.instance.frequencyMB!,"identifier":          DataManager.instance.identifierMB!,"customer_account_limit": customer_account_limit! ?? ""] as [String : Any]
        //
        let header: HTTPHeaders = ["Accept":"application/json" ,"Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    
                    if self.genericResponse?.response == 2 || self.genericResponse?.response == 1 {
                        self.startTimer()
                        
                        
                        //                        if let message = self.genericResponse?.message{
                        //                            self.showAlert(title: "", message: message, completion: {
                        //                                self.navigationController?.popToRootViewController(animated: true)
                        //                            })
                        //                        }
                        
                        if let message = self.genericResponse?.message{
                            self.showAlert(title: "", message: message, completion: {
                                //                            self.navigationController?.popToRootViewController(animated: true)
                                //                           circluar 4 changes
                                
                                self.logoutUser()
                                
                                //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC")
                                //                                as! RegistrationVC
                                //                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                            })
                            //                        self.showAlert(title: "", message: message, completion: {
                            //                            self.navigationController?.popToRootViewController(animated: true)
                            //                        })
                        }
                    }
                    else {
                        if let message = self.genericResponse?.message{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.genericResponse?.message{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
            
        }
    }
    func logoutUser2() {
        UserDefaults.standard.synchronize()

        DataManager.instance.accessToken = nil
        DataManager.instance.accountTitle = ""
        DataManager.instance.beneficaryTitle = nil
        DataManager.instance.imei = nil
        DataManager.instance.Latitude = nil
        DataManager.instance.Longitude = nil

        reloadStoryBoard2()
    }

     func reloadStoryBoard2() {

        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard(name: storyBoardName,bundle: nil)

        delegate.window?.rootViewController = storyBoard.instantiateInitialViewController()
    }
}
