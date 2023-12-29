//
//  RegistrationVC.swift
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
import Security
import ObjectMapper
import FingerprintSDK

class RegistrationVC: BaseVC , UITextFieldDelegate {
    
    var fingerprintPngs : [Png]?
    
    
    var  kSecClassGZenericpassword: CFString!
    
    
    @IBOutlet  var mobileNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet  var cnicTextField: SkyFloatingLabelTextField!
    @IBOutlet  var accountNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var btnTA: UIButton!
    @IBOutlet weak var lblPleaseAcceptT: UILabel!
    @IBOutlet weak var lblRegistrationUrself: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    var termsAccepted:Bool?
    @IBOutlet weak var checkboxButton: UIButton!
    
    var fromScreen:String?
    var registerInfo:Registeration?
    
    static let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        termsAccepted = false
        ChangeLanguage()
        let mobileNo = self.mobileNumberTextField.text
        let cnic = self.cnicTextField.text
        let accounNo = self.accountNumberTextField.text
        
        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: mobileNo,
            //            kSecAttrAccount as String: cnic,
            //            kSecAttrAccount as String: accounNo
        ]
        // Add user
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("User saved successfully in the keychain")
        } else {
            print("Something went wrong trying to save the user in the keychain")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ChangeLanguage()
    {
        
        lblMainTitle.text = "Register".addLocalizableString(languageCode: languageCode)
        btnNext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnTA.setTitle("Terms & Conditions".addLocalizableString(languageCode: languageCode), for: .normal)
        lblPleaseAcceptT.text = "Please accept Terms & Conditions".addLocalizableString(languageCode: languageCode)
        mobileNumberTextField.placeholder = "Enter Your Mobile Number".addLocalizableString(languageCode: languageCode)
        cnicTextField.placeholder =
        "Enter Your CNIC Number".addLocalizableString(languageCode: languageCode)
        accountNumberTextField.placeholder = "Enter Your Account Number".addLocalizableString(languageCode: languageCode)
        
        lblRegistrationUrself.text = "Register yourself with Access Banking".addLocalizableString(languageCode: languageCode)
    }
    
    private func updateUI(){
        
        if let screen = fromScreen{
            if screen == "signup"{
                lblMainTitle.text = "Register"
            }
            else{
                self.lblMainTitle.text = "Forgot Password"
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func nextToVerifyOTP(_ sender: Any) {
//        DispatchQueue.main.async {
//            self.fingerPrintVerification()
//        }
//
//        return()
        
        if mobileNumberTextField.text?.count == 0{
            return
        }
        if cnicTextField.text?.count == 0{
            return
        }
        
        if accountNumberTextField.text?.count == 0{
            return
        }
        
        if cnicTextField.text?.count ?? 0  < 13 {
            showToast(title: "Please Enter 13 Digit CNIC Number")
        }
        else{
            if self.termsAccepted! {
                
                self.showAlert(title: "We will send an OTP Code on your mobile number via SMS", message: self.mobileNumberTextField.text!, completion:{
                    
                    self.registrationCall()
                })
                
            }
            
            else{
                
                self.showDefaultAlert(title: "Terms & Conditions", message: "Please accept Terms & Conditions")
                //  self.showAlert(title: "Terms & Conditions", message: "Please accept Terms & Conditions", completion: nil)
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
    @IBAction func acceptTermsPressed(_ sender: Any) {
        termsAccepted = !termsAccepted!
        
        if termsAccepted! {
            
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
        }
        
        else {
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        }
    }
    @IBAction func TermsAndConditionPressed(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
        webVC.forHTML = true
        webVC.forTerms = true
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    // MARK: - UITextfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == mobileNumberTextField{
            return newLength <= 11
        }
        if textField == cnicTextField{
            return newLength <= 13
        }
        if textField == accountNumberTextField{
            return newLength <= 16
        }
        else {
            return newLength <= 16
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == mobileNumberTextField {
            cnicTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
        } else if textField == cnicTextField {
            accountNumberTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
        } else if textField == accountNumberTextField {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: - API CALL
    private func registrationCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        if (mobileNumberTextField.text?.isEmpty)! {
            mobileNumberTextField.text = ""
        }
        if (cnicTextField.text?.isEmpty)! {
            cnicTextField.text = ""
        }
        if (accountNumberTextField.text?.isEmpty)! {
            accountNumberTextField.text = ""
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Register"
        
        let params = ["cnic":cnicTextField.text!,"mobile_number":mobileNumberTextField.text!,"account":accountNumberTextField.text!,"mobile_company":"Apple","mobile_imei":DataManager.instance.imei!,"mobile_model":UIDevice.current.model,"ip_address":DataManager.instance.ipAddress!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
        
        
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            
            //        NetworkManager.sharedInstance.serverRequest().request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Registeration>) in
            
            //     Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Registeration>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.registerInfo = Mapper<Registeration>().map(JSONObject: json)
                
                if let cnic = self.cnicTextField.text {
                    DataManager.instance.userCnic = cnic
                }
                if let cnic = self.cnicTextField.text{
                    let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
                    print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                }
                if let accountno = self.accountNumberTextField.text{
                    let savedvalue : Bool = KeychainWrapper.standard.set(accountno, forKey: "AccountNo")
                    print("Account No SuccessFully Added to KeyChainWrapper \(savedvalue)")
                }
                
                if let mobileNo = self.mobileNumberTextField.text{
                    let mobileValuesaved : Bool = KeychainWrapper.standard.set(mobileNo, forKey: "MobNo")
                    print("Mobile No SuccessFully Added to KeyChainWrapper \(mobileValuesaved)")
                }
                
                if response.response?.statusCode == 200 {
                    if self.registerInfo?.response == 2 || self.registerInfo?.response == 1 {
                        if let accessToken = self.registerInfo?.data?.token {
                            DataManager.instance.regAccessToken = accessToken
                        }
                        let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                        OTPVerifyVC.mainTitle = "Enter OTP for Registration"
//                        OTPVerifyVC.registrationToken = registerInfo?.data?.token
                        self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
                    }
                    else {
                        if let message = self.registerInfo?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                OTPVerifyVC.mainTitle = "Enter OTP for Registration"
                                self.navigationController!.pushViewController(OTPVerifyVC, animated: true)})
                        }
                    }
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
    
    func bioVerisys2(fingerprints: [[String:Any]]) {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
//        let params = ["cnic":cnicTextField.text!,"mobile_number":mobileNumberTextField.text!,"account":accountNumberTextField.text!,"mobile_company":"Apple","mobile_imei":DataManager.instance.imei!,"mobile_model":UIDevice.current.model,"ip_address":DataManager.instance.ipAddress!]
        
        let jsonDataaa = try! JSONSerialization.data(withJSONObject: fingerprints as Any, options: .prettyPrinted)
        let decoded = try! JSONSerialization.jsonObject(with: jsonDataaa, options: [])
//            print(decoded)
        
        let params = [
            "TEMPLATE_TYPE": "ISO_19794_2",
            "LOCATION_LAT": "2.17403",
            "LOCATION_LONG": "41.40338",
            "imei":"\(DataManager.instance.imei ?? "")",
            "nadra":decoded
        ]
        
//        let parameters: Parameters = [
//            "cnic" : userCnic!,
//            "imei" : DataManager.instance.imei!,
//            "channelId" : "\(DataManager.instance.channelID)",
//        ]
//        APIs.postAPIForFingerPrint(apiName: .acccountLevelUpgrade, parameters: parameters, apiAttribute3: fingerprints, viewController: self) {
//            responseData, success, errorMsg in
//
//            print(responseData)
//            print(success)
//            print(errorMsg)
//            do {
//                let json: Any? = try JSONSerialization.jsonObject(with: (responseData ?? Data()), options: [.fragmentsAllowed])
//                print(json)
//            }
//            catch let error {
//                print(error)
//            }
//
//            let model: FingerPrintVerification.ModelAcccountLevelUpgradeResponse? = APIs.decodeDataToObject(data: responseData)
//            self.modelAcccountLevelUpgradeResponse = model
//        }
    }
    
    private func bioVerisys(fingerprints: [[String:Any]]) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        if (mobileNumberTextField.text?.isEmpty)! {
            mobileNumberTextField.text = ""
        }
        if (cnicTextField.text?.isEmpty)! {
            cnicTextField.text = ""
        }
        if (accountNumberTextField.text?.isEmpty)! {
            accountNumberTextField.text = ""
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/BioVerisys"
        let jsonDataaa = try! JSONSerialization.data(withJSONObject: fingerprints as Any, options: .prettyPrinted)
        let decoded = try! JSONSerialization.jsonObject(with: jsonDataaa, options: [])
//            print(decoded)
        
        let params = [
            "TEMPLATE_TYPE": "ISO_19794_2",
            "LOCATION_LAT": "2.17403",
            "LOCATION_LONG": "41.40338",
            "imei":"\(DataManager.instance.imei ?? "")",
            "nadra":decoded
        ]
        
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            
            //        NetworkManager.sharedInstance.serverRequest().request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Registeration>) in
            
            //     Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Registeration>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.registerInfo = Mapper<Registeration>().map(JSONObject: json)
                
                if let cnic = self.cnicTextField.text {
                    DataManager.instance.userCnic = cnic
                }
                if let cnic = self.cnicTextField.text{
                    let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
                    print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                }
                if let accountno = self.accountNumberTextField.text{
                    let savedvalue : Bool = KeychainWrapper.standard.set(accountno, forKey: "AccountNo")
                    print("Account No SuccessFully Added to KeyChainWrapper \(savedvalue)")
                }
                
                if let mobileNo = self.mobileNumberTextField.text{
                    let mobileValuesaved : Bool = KeychainWrapper.standard.set(mobileNo, forKey: "MobNo")
                    print("Mobile No SuccessFully Added to KeyChainWrapper \(mobileValuesaved)")
                }
                
                if response.response?.statusCode == 200 {
                    if self.registerInfo?.response == 2 || self.registerInfo?.response == 1 {
                        if let accessToken = self.registerInfo?.data?.token {
                            DataManager.instance.regAccessToken = accessToken
                        }
                        let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                        OTPVerifyVC.mainTitle = "Enter OTP for Registration"
                        self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
                    }
                    else {
                        if let message = self.registerInfo?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                OTPVerifyVC.mainTitle = "Enter OTP for Registration"
                                self.navigationController!.pushViewController(OTPVerifyVC, animated: true)})
                        }
                    }
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

extension  RegistrationVC: FingerprintResponseDelegate {
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
extension RegistrationVC {
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
