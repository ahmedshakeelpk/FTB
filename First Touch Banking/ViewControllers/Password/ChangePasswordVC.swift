//
//  ChangePasswordVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 16/03/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper

class ChangePasswordVC: BaseVC , UITextFieldDelegate {
    
    @IBOutlet weak var enterOldPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enterPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enterConfirmPassTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblpassworddetail: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet var btn_6characters: UIButton!
    @IBOutlet var btn_4digits: UIButton!
    @IBOutlet var btn_atLeast2Letters: UIButton!
    @IBOutlet var btn_ChangePass: UIButton!
    
    @IBOutlet weak var btnChangePass: FTBButton!
    var genericObj:GenericResponse?
    
    
    var callSubmit:Bool = false
    
    
    static let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguuage()
        // Do any additional setup after loading the view.
        
        self.btn_ChangePass.isEnabled = false
        
    }
    
    func ChangeLanguuage()
    {
        lblMain.text = "Change Password".addLocalizableString(languageCode: languageCode)
        enterOldPassTextField.placeholder = "Enter Old password".addLocalizableString(languageCode: languageCode)
        enterPassTextField.placeholder = "Enter New Password".addLocalizableString(languageCode: languageCode)
        enterConfirmPassTextField.placeholder = "Enter Confirm password".addLocalizableString(languageCode: languageCode)
        btnChangePass.setTitle("CHANGE PASSWORD".addLocalizableString(languageCode: languageCode), for: .normal)
        lblpassworddetail.text = "Password should be 6 characters (alpha numeric)".addLocalizableString(languageCode: languageCode)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                btn_ChangePass.isEnabled = true
            }
            else {
                callSubmit = false
                btn_ChangePass.isEnabled = false
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
    
    @IBAction func ChangePassButtonPressed(_ sender: Any) {
        
        if let pessi = KeychainWrapper.standard.string(forKey: "userKey"){
            if enterOldPassTextField.text != pessi{
                self.showToast(title: "Enter valid old password")
                return
            }
        }
        if enterPassTextField.text?.count == 0 {
            return
        }
        if enterConfirmPassTextField.text?.count == 0{
            return
        }
        if enterPassTextField.text != enterConfirmPassTextField.text! {
            return
        }
        self.changePassword()
    }
    
    // MARK: - API CALL
    
    private func changePassword() {
        
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
        
        if let Enterpassword = self.enterPassTextField.text{
            let savedvalue : Bool = KeychainWrapper.standard.set(Enterpassword, forKey: "Enterpassword")
            print("password SuccessFully Added to KeyChainWrapper \(savedvalue)")
        }
        if let EnterNewPassowrd = self.enterConfirmPassTextField.text{
            let savedvalue : Bool = KeychainWrapper.standard.set(EnterNewPassowrd, forKey: "EnterNewPassowrd")
            print("Confirm Password SuccessFully Added to KeyChainWrapper \(savedvalue)")
        }
        
        if let EnterConfirmPassowrd = self.enterConfirmPassTextField.text{
            let mobileValuesaved : Bool = KeychainWrapper.standard.set(EnterConfirmPassowrd, forKey: "EnterConfirmPassowrd")
            print("Account No SuccessFully Added to KeyChainWrapper \(mobileValuesaved)")
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/ChangePassword"
        
        let params = ["old_password":self.enterOldPassTextField.text!,"password":self.enterPassTextField.text!,"password_confirmation":self.enterConfirmPassTextField.text!]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
//                    self.genericObj = response.result.value
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        if let message = self.genericObj?.message{
                            let removePessi : Bool = KeychainWrapper.standard.removeObject(forKey: "userKey")
                            print("Remover \(removePessi)")
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    else {
                        if let message = self.genericObj?.message{
                            self.showAlert(title: "", message: message, completion:nil)
                        }
                    }
                }
                else {
                    if let message = self.genericObj?.message{
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
