//
//  EnterPasswordVC.swift
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


class EnterPasswordVC: BaseVC , UITextFieldDelegate {
    
    @IBOutlet weak var enterPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enterConfirmPassTextField: SkyFloatingLabelTextField!
    var enterpassObj:EnterPassword?
    
    var uniqueKey : String?
    
    @IBOutlet weak var btnRegis: FTBButton!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet var btn_6characters: UIButton!
    @IBOutlet var btn_4digits: UIButton!
    @IBOutlet var btn_atLeast2Letters: UIButton!
    @IBOutlet var btn_Register: UIButton!
    
    var callSubmit:Bool = false

    static let networkManager = NetworkManager()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        // Do any additional setup after loading the view.
        
           self.btn_Register.isEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ChangeLanguage()
    {  
        lblMain.text = "Enter Password for Registration".addLocalizableString(languageCode: languageCode)
        enterPassTextField.placeholder = "Enter New Password".addLocalizableString(languageCode: languageCode)
        enterConfirmPassTextField.placeholder = "Enter Confirm password".addLocalizableString(languageCode: languageCode)
        btnRegis.setTitle("REGISTER NOW".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == self.enterPassTextField {
            if range.length + range.location > (textField.text?.count)! {
                return false
            }
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            
//            // Password should contain 6 characters
//
//            let capitalLetterRegEx  = ".*[a-z]+.*"
//            let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
//            let capitalresult = texttest.evaluate(with: newString)
//            if capitalresult == true{
//                self.btn_atLeast2Letters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
//            }
//            else{
//                self.btn_atLeast2Letters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
//            }
//            print("\(capitalresult)")
            
            // Password should alphanumeric characters
            
            let capitalLetterRegEx  = "[^a-zA-Z0-9]"
            let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            let capitalresult = texttest.evaluate(with: newString)
            if capitalresult == true{
                self.btn_atLeast2Letters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
            }
            else{
                self.btn_atLeast2Letters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
            }
            print("\(capitalresult)")
            
            // Password should contain 4 Digits  ^a-zA-Z0-9
            
            let numberRegEx  = ".*[0-9]+.*"
            let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let numberresult = texttest1.evaluate(with: newString)
            if numberresult == true{
                self.btn_4digits.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
            }
            else{
                self.btn_4digits.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
            }
            print("\(numberresult)")
            
            let rangeCharacterRegEx  = "^.{6,}$"
            let texttest3 = NSPredicate(format:"SELF MATCHES %@", rangeCharacterRegEx)
            let rangeResult = texttest3.evaluate(with: newString)
            if rangeResult == true{
                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
            }
            else{
                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
            }
            print("\(rangeResult)")
            
            
            if rangeResult == true && numberresult == true /*&& newString.count == 6*/{
                callSubmit = true
                btn_Register.isEnabled = true
            }
            else {
                callSubmit = false
                btn_Register.isEnabled = false
            }
           
        }
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        
        if textField == enterPassTextField{
            return newLength <= 6
        }
        if textField == enterConfirmPassTextField{
            return newLength <= 6
        }
        return newLength <= 6
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == enterPassTextField {
            enterConfirmPassTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
        } else if textField == enterConfirmPassTextField {
            textField.resignFirstResponder()
        }
    }
    // MARK: - Action Methods
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if enterPassTextField.text?.count == 0 {
            return
        }
        if enterConfirmPassTextField.text?.count == 0{
            return
        }
        if enterPassTextField.text != enterConfirmPassTextField.text! {
            self.showDefaultAlert(title: "Error", message: "Password and Confirm Password is not match")
            return
        }
        self.enterPassword()
    }
    
    // MARK: - API CALL
    
    private func enterPassword() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        if (enterPassTextField.text?.isEmpty)! {
            enterPassTextField.text = ""
        }
        if (enterConfirmPassTextField.text?.isEmpty)! {
            enterConfirmPassTextField.text = ""
        }
        
        if let password = self.enterPassTextField.text{
            let savedvalue : Bool = KeychainWrapper.standard.set(password, forKey: "Password")
            print("password SuccessFully Added to KeyChainWrapper \(savedvalue)")
        }
        if let ConfirmPassword = self.enterConfirmPassTextField.text{
            let savedvalue : Bool = KeychainWrapper.standard.set(ConfirmPassword, forKey: "ConfirmPassword")
            print("Confirm Password SuccessFully Added to KeyChainWrapper \(savedvalue)")
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Password"
        
        let params = ["cnic":DataManager.instance.userCnic!,"pin_code":enterPassTextField.text!,"unique_key":uniqueKey!]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.regAccessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        //    let header = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
        
        
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        //
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<EnterPassword>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<EnterPassword>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.enterpassObj = Mapper<EnterPassword>().map(JSONObject: json)
                    
                    if self.enterpassObj?.response == 2 || self.enterpassObj?.response == 1 {
                        if let message = self.enterpassObj?.message{
                            let removePessi : Bool = KeychainWrapper.standard.removeObject(forKey: "userKey")
                            print("Remover \(removePessi)")
                            self.showAlert(title: "", message: message, completion: {
                                DataManager.instance.isFromRegisteration = true
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
                    }
                    else {
                        if let message = self.enterpassObj?.message{
                            self.showAlert(title: "", message: message, completion:nil)
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
}
