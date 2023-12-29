//
//  OTPVerifyVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper
import FingerprintSDK

class OTPVerifyVC: BaseVC {
//    var fingerPrintVerification: FingerPrintVerification!
    var fingerprintPngs : [Png]?
    var registrationToken: String!

    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var otpTextField: SkyFloatingLabelTextField!
    var verifyOTPInfo:VerifyOTP?
    var genericObj:GenericResponse?
    @IBOutlet weak var lblMainTitle: UILabel!
    var mainTitle:String?
    var FromProfileUpdate:Bool = false
    var ForTransactionConsent:Bool = false
    var userCnic : String?
    var genericResponse:GenericResponse?
    var sourceAccount:String?
    var uniqueStringResponse: String?
    
    @IBOutlet weak var lblOTPSEnd: UILabel!
    
    @IBOutlet weak var btnnext: UIButton!
    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnresendotp: FTBButton!
    @IBOutlet weak var lblDetail: UILabel!
    static let networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguage()
        
        
        self.clearAllFields()
        
        if ForTransactionConsent == true{
            self.getOTPCallForConsent()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func Changelanguage()
    {
        lblMain.text = "Enter OTP for Registration".addLocalizableString(languageCode: languageCode)
        lblOTPSEnd.text = "OTP has been sent via SMS".addLocalizableString(languageCode: languageCode)
        otpTextField.placeholder = "Enter OTP".addLocalizableString(languageCode: languageCode)
        lblDetail.text = "Enter the code sent on your mobile device manually.".addLocalizableString(languageCode: languageCode)
        btnnext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnback.setTitle("Back".addLocalizableString(languageCode: languageCode), for: .normal)
        btnresendotp.setTitle("Tap here to receive OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Methods
    
    private func clearAllFields(){
        self.otpTextField.text = ""
    }
    
    // MARK: - Action Methods
    
    @IBAction func nextToEnterPass(_ sender: Any) {
        
        if otpTextField.text?.count == 0 {
            return
        }
        if self.ForTransactionConsent == true{
            self.sendTransactionConsent()
        }
        else if self.FromProfileUpdate == true{
            self.saveProfileUpdates()
        }
        else{
            self.verifyOTPCall()
        }
    }
    
    @IBAction func callForOtpPressed(_ sender: Any) {
        
        if ForTransactionConsent == true{
            self.getOTVCallForConsent()
        }
        if self.FromProfileUpdate == true{
            self.callForOTPForPrifleUpdate()
        }
        else{
            self.callForOTP()
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if self.ForTransactionConsent == true{
            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    
    
    // MARK: - API CALL
    
    
    private func getOTPCallForConsent() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/\(self.sourceAccount!)/TransactionConsent/OTP"
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
                    
                    if self.genericResponse?.response == 0 {
                        
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
    
    private func getOTVCallForConsent() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/\(self.sourceAccount!)/TransactionConsent/OTV"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                    //                self.genericResponse = response.result.value
                    if self.genericResponse?.response == 0 {
                        
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
    
    private func callForOTP() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        if FromProfileUpdate == true {
            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
            }
        }
        else if ForTransactionConsent == true {
            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
            }
        }
        else{
            userCnic = DataManager.instance.userCnic
        }
        
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/OTV"
        
        //   let params = []
        //       let header = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.regAccessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        
        //     print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            
            //        Alamofire.request(compelteUrl, method: .post , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .post , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                
                if response.response?.statusCode == 200 {
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        
                        if let message = self.genericObj?.message{
                            self.showToast(title: message)
                        }
                    }
                }
                else {
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func callForOTPForPrifleUpdate() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        if FromProfileUpdate == true {
            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
            }
        }
        else if ForTransactionConsent == true {
            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
            }
        }
        else{
            userCnic = DataManager.instance.userCnic
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Profile/OTV"
        
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        
        //     print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            
            //
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        
                        if let message = self.genericObj?.message{
                            self.showToast(title: message)
                        }
                    }
                }
                else {
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    private func verifyOTPCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        if (otpTextField.text?.isEmpty)! {
            otpTextField.text = ""
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/OTP"
        
        if FromProfileUpdate == true {
            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
            }
        }
        else if ForTransactionConsent == true {
            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
            }
        }
        else{
            userCnic = DataManager.instance.userCnic
        }
        
        let params = ["otp":otpTextField.text!]
        
        //      let header = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.regAccessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<VerifyOTP>) in
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            //
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.verifyOTPInfo = Mapper<VerifyOTP>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    
                    if self.verifyOTPInfo?.response == 2 || self.verifyOTPInfo?.response == 1 {
                        //CallSdk
                        //is ka success me OTPVerifyVC idhar jana ha
                        DispatchQueue.main.async {
//                            self.fingerPrintVerification()
                            
                            var tempFingerPrintDictionary = [[String:Any]]()

                            tempFingerPrintDictionary.append(
                                [
                                 "FINGER_TEMPLATE":thumbOne,
                                 "FINGER_INDEX":"6"
//                                 ,"templateType":"WSQ"
                                ]
                            )
                            
                            tempFingerPrintDictionary.append(
                                [
                                 "FINGER_TEMPLATE":thumbTwo,
                                 "FINGER_INDEX":"1"
//                                 ,"templateType":"WSQ"
                                ]
                            )
                            self.bioVerisys(fingerprints: tempFingerPrintDictionary)
                        }
                        
                        
                        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterPasswordVC") as! EnterPasswordVC
                        if let key = self.verifyOTPInfo?.data?.unique_key {
                            nextVC.uniqueKey = key
                        }
//                        self.navigationController!.pushViewController(nextVC, animated: true)
                        
                    }
                    else {
                        if let message = self.verifyOTPInfo?.message {
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                }
                else {
                    if let message = self.verifyOTPInfo?.message {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                    //                if let message =  self.shopInfo?.resultDesc{
                    //                    self.showAlert(title: Localized("error"), message: message, completion: nil)
                    //                }
                    //                else{
                    //                    self.showAlert(title: Localized("error"), message:Constants.ERROR_MESSAGE, completion: nil)
                    //                }
                }
            }
        }
    }
    var modelAcccountLevelUpgradeResponse: ModelAcccountLevelUpgradeResponse? {
        didSet {
            print(modelAcccountLevelUpgradeResponse)
            if modelAcccountLevelUpgradeResponse?.responsecode == 1 {
                NotificationCenter.default.post(name: Notification.Name("updateAccountLevel"), object: nil)

//                self.showAlertCustomPopup(title: "Success", message: modelAcccountLevelUpgradeResponse?.messages ?? "SUCCESS FROM API") {_ in
//
//                }
            }
            else if modelAcccountLevelUpgradeResponse?.responsecode == 0 {
//                self.showAlertCustomPopup(title: "Error", message: modelAcccountLevelUpgradeResponse?.messages ?? "No Message from API") {_ in
//
//                }
            }
            else {
//                self.showAlertCustomPopup(title: "Error", message: "ERROR IN RESPONSE API") {_ in
//
//                }
            }
        }
    }
    
    func fingerPrintVerification() {
        //#if targetEnvironment(simulator)
        //        #else

        let customUI = CustomUI(
            topBarBackgroundImage: nil,
            topBarColor: UIColor.red,
            topBarTextColor: UIColor.white,
            containerBackgroundColor: UIColor.white,
            scannerOverlayColor: UIColor.green,
            scannerOverlayTextColor: UIColor.white,
            instructionTextColor: UIColor.white,
            buttonsBackgroundColor: UIColor.red,
            buttonsTextColor: UIColor.white,
            imagesColor: UIColor.green,
            isFullWidthButtons: true,
            guidanceScreenButtonText: "NEXT",
            guidanceScreenText: "User Demo",
            guidanceScreenAnimationFilePath: nil,
            showGuidanceScreen: true)

        let customDialog = CustomDialog(
            dialogImageBackgroundColor: UIColor.white,
            dialogImageForegroundColor: UIColor.green,
            dialogBackgroundColor: UIColor.white,
            dialogTitleColor: UIColor.green,
            dialogMessageColor: UIColor.black,
            dialogButtonTextColor: UIColor.white,
            dialogButtonBackgroundColor: UIColor.orange)
        
        let uiConfig = UIConfig(
            splashScreenLoaderIndicatorColor: UIColor.black,
            splashScreenText: "Please wait",
            splashScreenTextColor: UIColor.white,
            customUI: customUI,
            customDialog: customDialog,
            customFontFamily: nil)
        
        let fingerprintConfig = FingerprintConfig(mode: .EXPORT_WSQ,
                                                  hand: .BOTH_HANDS,
                                                  fingers: .TWO_THUMBS,
                                                  isPackPng: true, uiConfig: uiConfig)
//        let fingerprintConfig = FingerprintConfig(
//            mode: .EXPORT_WSQ,
//            hand: .BOTH_HANDS,
//            fingers: .TWO_THUMBS,
//            liveness: true,
//            isPackPng: false)
        
        let vc = FaceoffViewController.init(nibName: "FaceoffViewController", bundle: Bundle(for: FaceoffViewController.self))
        
        vc.fingerprintConfig = fingerprintConfig
        vc.fingerprintResponseDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.present(vc, animated: true, completion: nil)
        }
        
        //        #endif
    }
    
    private func sendTransactionConsent() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/TransactionConsent"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"AccountNumber":self.sourceAccount!,"TransactionConsent":1,"TransactionOTP":self.otpTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        
        // Change Before Live
        
        //        NetworkManager.sharedInstance.enableCertificatePinning()
        //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
        //
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //             Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.genericResponse?.response == 2 || self.genericResponse?.response == 1 {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        if let message = self.genericResponse?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    public func saveProfileUpdates() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "/api/v1/Customers/Profile"
        
        let params = ["customer_cnic":DataManager.instance.userCnic!,"customer_no":DataManager.instance.customer_no!,"mobile_number":DataManager.instance.mobile_number!,"email_address":DataManager.instance.email_address!,"current_address_line_1":DataManager.instance.current_address_line_1!,"current_address_line_2":DataManager.instance.current_address_line_2!,"current_address_line_3":DataManager.instance.current_address_line_3!,"correspondence_address_line_1":DataManager.instance.correspondence_address_line_1!,"correspondence_address_line_2":DataManager.instance.correspondence_address_line_2!,"correspondence_address_line_3":DataManager.instance.correspondence_address_line_3!,"marital_status":DataManager.instance.marital_status!,"country_of_birth":DataManager.instance.country_of_birth!,"country_of_stay":DataManager.instance.country_of_stay!,"country_of_tax_residence":DataManager.instance.country_of_tax_residence!,"otp":otpTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        AF.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.genericResponse?.response == 2 || self.genericResponse?.response == 1 {
                        // Success Message
                        if let message = self.genericResponse?.message{
                            self.showAlert(title: "", message: message, completion:{
                                let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                                self.navigationController!.pushViewController(profileVC, animated: true)
                            })
                        }
                    }
                    else {
                        if let message = self.genericResponse?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: “”, message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.genericResponse?.message{
                        self.showAlert(title: "", message: message, completion:{
                            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                            self.navigationController!.pushViewController(profileVC, animated: true)
                        })
                    }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}

var thumbOne = "iVBORw0KGgoAAAANSUhEUgAAAZsAAAKUCAAAAAD3TcpsAAAgAElEQVR4AeS9d3gd1bU3vE/vvTedIx31asmy5I5xwYBtML0FQghcLk4P6T034UJuCknuDeHSAgkdbGMbg7stF1myrN6lo1N0eu+9vWuP7Lx5//zANjzPt/6Y2bPLzJ69Zq/1W2uXIZXR54zKsZwMoed+FkSoq1mpX9WC65f3lbX/t56xkTPnbXRaPxHz2F9ol1Km958a8uHwDVs3ty7FlZDr1Z/i4JefqOGRcMD/0q/SqO0H9+LwwICV3LFZjIOfR6L84nNWq3LYLOAg0+u44RU6EV+hgvb8w5O/em1mmeByVRmpUFHWulw8iSN4bBl3KYGeIjFRCD62YtyTVDFxJIlEDQ9EINAsziYyiXiBUohFXcx6oxGSc5Eygy+RCDIlytINPmdH0uer3+TJ2QBZQUu+9mPcoPesEjN1jayT35jBrcb4eQOJymJI6xBKjEU10DOmdvUg0go0E0OCe+9ZR0Vxr985NTrvi2YQ2nL7+hqiQyX3v9pD6mwTcyRicpam1eYmxwJ0uVotoFFolGwsh9I+XpuA9znjC67O54s37qiUywDR437pzwHEe/DO+myIKo6/+4ulhhNUkmkclrK9W5cKiSuX4iZ8to/eJ4K3PrJczIKQfXRq6MMkQpU3raxX8nFf881HCslAmslO+9KajjpGxB8I+BNUqb5SQY0H3JYFb2nTbcKl+32ejp8rmTZ/sMiSkXHz+Mmytbu+Ws8TSmjMcsJrJ5pMVYwFbBPDH/UOTdmLjUutKK9sX5MdwOFZV9iT1SAkqF3Trve7EEq7Zwf67Uoe4lTU1qslIiEzH3C4wmnEFgiomUg0XcgEF13RfKmQjswWqFz60h0/P8fPT7/xR3MfURSVRjk0TmrUlNd3XtIvRa9pMcOmZ1MRvz/onkoRjVe3fvPqf6KDl74XhkihjN+44zYqkTzVZwlFfCYrQj94mohAKBRNBudHZsO86pYGFSng8CRLhYA"

var thumbTwo = "iVBORw0KGgoAAAANSUhEUgAAAaMAAAKVCAAAAABHNdsFAAAgAElEQVR4Aey9Z3hcx5Eo2pNzzjPAYAAMciIywACCOUlUTpaVnNeyrbV9vU7rXaeVdi1711rLUZYsWbKoRImkJJJiziQAIuc0mJxzzvOqD0BZvu++PytQpL936/umY50+3V3dVdXVfXpIBfT3AYXzzI6/remPfkh68IvrEbLMypr+Ngdii4Pe6s0fpkZJUYuX38j9MOHvKkD9e6mtebbkf6vqDCrE85DGoKX+muOze1NMIS+5MB1gfJgasiUDJjcnt5aCk7IF2oc5fxeBvxsaldCGyvTLXTpbhX3jCEJsYmakvOQm6PaJ9654ktEYRVFVqaI4zRGpV7pCAvu8x7FoIS8lunk+g5skkKp5Kzl/F97fDY1CwwOze28nQafu+0tqy0Ma1M9G+lJSiuacmbYMT1VQh/7Ut9zjJC1i8BhkJ9m+QqNITkghJ+PRRDSPLKfMan3YrKolo7Sfx/m/NFqlHvCMs2SuAwfMk2OHNnSJFwau+E48d3+9p61USL18ORqNenwsikQtwhSRNanFRZVlcporOzdtalM6hmyShqriBjHyLrq5nWyk5fB0jaxwfsl76appb0NhnWCVKnkdiyH9HegMD76KKMJIGnqB1tBdkZ846ENIsrOclgw6zfYEXy2gKzu3aDMf7J8Wd66vlRLS5tRv9l/rNcW9e7bj+bcMY/FWQIi7L750HCec7l1Ovpndm5rXeWS46069ilDOh0SKnCOHCpk8mQ808hkYvKhxxoZQWiWWl9cVI5qiMpMvIMEyiZ459GGvuyxGY+m1WCjJB4RYKJrj0DHV36Z1EA9cy78Z/ZuXRkNGsucWFfTZOaLfKpu0OXuhdg3PYsDamaTgj0aDFCmFr9AIuczEVGD4woCxUDTn6CxihEYPvPdhZ1MbKYunLdKcy+zPk0LWuLyY7IpKiqhNzOFZhH4VX/ch5s0auHlpdOU1n3K6Ts22QU8iemNjo57myWiU4aD"





extension  OTPVerifyVC: FingerprintResponseDelegate {
    func onScanComplete(fingerprintResponse: FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
            //            print(fingerprintResponse.response)
            //            print(fingerprintResponse.response)
            
            
            fingerprintPngs = fingerprintResponse.pngList
            var fingerprintsList = [Fingerprints]()
            
            var tempFingerPrintDictionary = [[String:Any]]()
            if let fpPNGs = fingerprintPngs {
                for item in fpPNGs {
                    guard let imageString = item.binaryBase64ObjectPNG else { return }
                    guard let instance = Fingerprints(fingerIndex: "\(item.fingerPositionCode)", fingerTemplate: imageString) else { return }
                    
                    tempFingerPrintDictionary.append(
                        ["FINGER_INDEX":"\(item.fingerPositionCode)",
                         "FINGER_TEMPLATE":imageString,
                         "templateType":"WSQ"]
                    )
                }
            }
            self.bioVerisys(fingerprints: tempFingerPrintDictionary)
        }else {
            //            self.showAlertCustomPopup(title: "Faceoff Results", message: fingerprintResponse.response.message, iconName: .iconError) {_ in
            //                self.dismiss(animated: true)
        }
    }
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
}
extension OTPVerifyVC {
    // MARK: - ModelFingerPrintResponse
    struct ModelAcccountLevelUpgradeResponse: Codable {
        let responsecode: Int
        let data, responseblock: JSONNull?
        let messages: String
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

    struct Fingerprints: Codable {
        var fingerIndex: String
        var fingerTemplate: String
        var templateType: String

        init?(fingerIndex: String, fingerTemplate: String) {
            self.fingerIndex = fingerIndex
            self.fingerTemplate = fingerTemplate
            self.templateType = ""
        }
    }
}

extension OTPVerifyVC {
    private func bioVerisys(fingerprints: [[String:Any]]) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/BioVerisys"
        let jsonDataaa = try! JSONSerialization.data(withJSONObject: fingerprints as Any, options: .prettyPrinted)
        let decoded = try! JSONSerialization.jsonObject(with: jsonDataaa, options: [])
            print(decoded)
        if let dicFromJson = decoded as? [[String:Any]] {
            print(dicFromJson)
            print(dicFromJson)
        }
        let decoded2 = try! JSONSerialization.jsonObject(with: jsonDataaa, options: .fragmentsAllowed)
        print(decoded2)
        if let dicFromJson = decoded2 as? [[String:Any]] {
            print(dicFromJson)
            print(dicFromJson)
        }
//        if let jsonsss = try? JSONSerialization.jsonObject(with: jsonDataaa2, options: []) {
//            print(jsonsss)
//            print(jsonsss)
//        }
        let params = [
            "TEMPLATE_TYPE": "ISO_19794_2",
            "LOCATION_LAT": "33.6844",
            "LOCATION_LONG": "73.0479",
            "imei":"\(DataManager.instance.imei ?? "")",
            "nadra":decoded
        ] as [String : Any]
        let jsonDataaaParams = try! JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        print(jsonDataaaParams)
        let decoded3 = try! JSONSerialization.jsonObject(with: jsonDataaaParams, options: [])
            print(decoded3)
        if let dicFromJson = decoded3 as? [[String:Any]] {
            print(dicFromJson)
            print(dicFromJson)
        }
        

//        let params = [
//            "TEMPLATE_TYPE": "ISO_19794_2",
//            "LOCATION_LAT": "\(DataManager.instance.Latitude!)",
//            "LOCATION_LONG": "DataManager.instance.Longitude!",
//            "imei":"\(DataManager.instance.imei ?? "")",
//            "nadra":decoded
//        ]
        
        let header: HTTPHeaders = [
            "Accept":"application/json",
            "Content-Type":"application/json",
            "Authorization":"Bearer \(DataManager.instance.regAccessToken!)"]
        print("Parameters Before Sending: \(params)")
        print("Url Before Sending: \(compelteUrl)")
        print("Token Before Sending: \(DataManager.instance.stringHeader!)")

        NetworkManager.sharedInstance.enableCertificatePinning()
        let url = URL(string: compelteUrl)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Authorization", forHTTPHeaderField: "Bearer \(DataManager.instance.regAccessToken!)")
                
        let jsonDataaa2 = try! JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        request.httpBody = jsonDataaa2
        if let jsonsss = try? JSONSerialization.jsonObject(with: jsonDataaa2, options: []) {
            print(jsonsss)
            print(jsonsss)
        }
        
        NetworkManager.sharedInstance.sessionManager?.request(request.url!, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { response in
            
            //        NetworkManager.sharedInstance.serverRequest().request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Registeration>) in
            
            //     Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Registeration>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                self.registerInfo = Mapper<Registeration>().map(JSONObject: json)
                print(json)
                if response.response?.statusCode == 200 {
//                    if self.registerInfo?.response == 2 || self.registerInfo?.response == 1 {
//                        if let accessToken = self.registerInfo?.data?.token {
//                            DataManager.instance.regAccessToken = accessToken
//                        }
//                        let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
//                        OTPVerifyVC.mainTitle = "Enter OTP for Registration"
//                        self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
//                    }
//                    else {
//                        if let message = self.registerInfo?.message{
//                            self.showAlert(title: "", message: message, completion: {
//                                let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
//                                OTPVerifyVC.mainTitle = "Enter OTP for Registration"
//                                self.navigationController!.pushViewController(OTPVerifyVC, animated: true)})
//                        }
//                    }
                }
                else {
//                    if let message = self.registerInfo?.mobile_number{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                    if let message = self.registerInfo?.cnic{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                    if let message = self.registerInfo?.mobile_number{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                    if let message = self.registerInfo?.message{
//                        self.showDefaultAlert(title: "Error", message: message)
//                    }
                    self.showDefaultAlert(title: "Error", message: "OTP cannot be sent. Please Try Again")
                    
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
