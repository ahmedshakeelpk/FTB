//
//  InterBankFundTransferConfirmationVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 14/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SkyFloatingLabelTextField
import ObjectMapper

class InterBankFundTransferConfirmationVC: BaseVC , UITextFieldDelegate {
    
    @IBOutlet weak var lblSourceAccountValue: UILabel!
    @IBOutlet weak var lblBeneficaryAccountValue: UILabel!
    @IBOutlet weak var lblBeneficaryBankName: UILabel!
    @IBOutlet weak var lblAccountTitleValue: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    
    @IBOutlet weak var lblTransferAmountTitle: UILabel!
    @IBOutlet weak var lblMainTitle : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblAddBeneficiary: UILabel!
    @IBOutlet weak var btnpaynow: UIButton!
    @IBOutlet weak var payNowButton: UIButton!
    
    @IBOutlet weak var btncancel: UIButton!
    var sourceAccount:String?
    var beneficaryAccount:String?
    var beneficaryBankName:String?
    var transferAmount:String?
    var singleBank : SingleBank?
    var titleFetched:Bool = false
    
    var TitleObj:TitleFetch?
    var ibftFundObj:IBFTFundTransfer?
    var genObj:GenericResponse?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var viewAddBeneficiary: UIView!
    @IBOutlet var btn_AddBene: UIButton!
    var addBeneficiary:Bool?
    @IBOutlet  var nickNameTextField: SkyFloatingLabelTextField!
    @IBOutlet  var mobileNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet  var emailTextField: UITextField!
    @IBOutlet weak var otpTextField: SkyFloatingLabelTextField!
    @IBOutlet var viewBottomButtonsUpperConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomButtonsDownConstraint: NSLayoutConstraint!
    static let networkManager = NetworkManager()
    
    var isFromHome:Bool = false
    @IBOutlet weak var lblAddBene: UILabel!
    @IBOutlet weak var lblSubmitPayNow: UILabel!
    
    
    
    @IBOutlet weak var lblPaynow: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        lblCancel.text = "CANCEL".addLocalizableString(languageCode: languageCode)
        
        self.clearAll()
        self.getTitle()
        self.updateUI()
        self.otpTextField.isHidden = true
        addBeneficiary = true
        emailTextField.delegate  = self
        emailTextField.keyboardType = .asciiCapable
        mobileNumberTextField.delegate = self
        btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true
        emailTextField.addTarget(self, action: #selector(emailFieldEditingChanged(_:)), for: .editingDidEnd)
        
        // Do any additional setup after loading the view.
    }
    @objc func emailFieldEditingChanged(_ textField: UITextField) {
        if isValidEmail(testStr: emailTextField.text!)
        {
            
            print("Valid Email ID")
            
            let EmailSaved = UserDefaults.standard.setValue(emailTextField.text, forKey: "EmailVerification")
            print("emailAddressTextField", EmailSaved)
            // self.showToast(title: "Validate EmailID")
        }
        else
        {
            print("Invalid Email ID")
            self.showDefaultAlert(title: "Error", message: "Invalid Email ID")
            //            return
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func isValidEmail(testStr:String) -> Bool {
        
        //        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
        
    }
    
    
    
    // MARK: - Utility Methods
    
    private func clearAll(){
        
        self.lblSourceAccountValue.text = ""
        self.lblBeneficaryAccountValue.text = ""
        self.lblBeneficaryBankName.text = ""
        self.lblAmountValue.text = ""
        self.lblAccountTitleValue.text = ""
        
    }
    
    private func updateUI(){
        
        if self.isFromHome == true{
            self.btn_AddBene.isHidden = false
            self.lblAddBene.isHidden = false
            self.lblTransferAmountTitle.isHidden = true
            self.lblAmountValue.isHidden = true
            self.lblMainTitle.text = "Add Beneficary".addLocalizableString(languageCode: languageCode)
            self.lblTitle.text = "Add Beneficary".addLocalizableString(languageCode: languageCode)
            self.lblSubmitPayNow.text = "SUBMIT".addLocalizableString(languageCode: languageCode)
            
            
            btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
            self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 998)
            self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 999)
            self.viewAddBeneficiary.isHidden = false
            self.scrollView.layoutIfNeeded()
            
        }
        else{
            self.lblSubmitPayNow.text = "PayNow".addLocalizableString(languageCode: languageCode)
            self.btn_AddBene.isHidden = true
            self.lblAddBene.isHidden = true
        }
        
        if let account = sourceAccount{
            self.lblSourceAccountValue.text = account
        }
        if let beneAccount = beneficaryAccount{
            self.lblBeneficaryAccountValue.text = beneAccount
        }
        if let beneBank = beneficaryBankName{
            self.lblBeneficaryBankName.text = beneBank
        }
        if let Tamount = transferAmount{
            self.lblAmountValue.text = "PKR \(Tamount).00"
        }
        self.lblAccountTitleValue.text = DataManager.instance.beneficaryTitle
        self.nickNameTextField.text = DataManager.instance.beneficaryTitle
    }
    
    private func navigateToDetailsVC(){
        let ibftFundsDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "InterBankFundTransferDetailsVC") as! InterBankFundTransferDetailsVC
        
        ibftFundsDetailsVC.sourceAccount = self.sourceAccount
        ibftFundsDetailsVC.beneficaryAccount = self.beneficaryAccount
        ibftFundsDetailsVC.beneficaryAccountTitle = DataManager.instance.beneficaryTitle
        ibftFundsDetailsVC.transferAmount = self.transferAmount
        ibftFundsDetailsVC.TransRefNumber = self.ibftFundObj?.stan
        ibftFundsDetailsVC.TransTime = self.ibftFundObj?.tran_time
        ibftFundsDetailsVC.beneficaryBankTitle = self.beneficaryBankName
        
        self.navigationController!.pushViewController(ibftFundsDetailsVC, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        
        
        
        let newLength = (textField.text?.count)! + string.count - range.length
        if textField == mobileNumberTextField
        {
            return  newLength <= 11
        }
        else  if textField == otpTextField
        {
            return  newLength <= 4
        }
        
        //        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
        //
        //            // Check if the replacement string contains only allowed characters
        //            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil {
        //                // Check for an existing decimal point in the text
        //                if let text = textField.text {
        //                    if string == "." && text.contains(".") {
        //                        return false
        //                    }
        //                }
        //                return true
        //            }
        //        else {
        //                return false
        //            }
        return true
    }
    
    
    
    
    // MARK: - Action Method
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    func checkEmailValid()
    {
        if isValidEmail(testStr: emailTextField.text!) == true {
            self.addBeneCall()
        }
        else
        {
            return()
        }
    }
    
    @IBAction func payNowPressed(_ sender: Any) {
        
        
        if addBeneficiary == false {
            if (self.nickNameTextField.text?.isEmpty)!{
                self.showDefaultAlert(title: "", message: "Enter Nickname")
                return
            }
        }
        if self.titleFetched == false {
            self.showDefaultAlert(title: "Error", message: "Try Again Please!")
            return
        }
        
        if isFromHome == true{
            if otpTextField.text?.count == 0 {
                return
            }
            if nickNameTextField.text?.count == 0{
                self.showToast(title: "Please enter Name of Beneficiary")
                return
            }
            //            add Logic here...
            if emailTextField.text?.count == 0
            {
                self.addBeneCall()
            }
            else
            {
                checkEmailValid()
            }
            
        }
        else{
            self.payIbftFundTransfer()
        }
        if isFromQR == "true"
        {
            self.payIbftFundTransfer()
        }
        
        
    }
    @IBAction func action_AddBeneficiary(_ sender: Any) {
        addBeneficiary = !addBeneficiary!
        
        if addBeneficiary! {
            btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
            self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
            self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
            self.viewAddBeneficiary.isHidden = true
            self.scrollView.layoutIfNeeded()
        }
        
        else {
            btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
            self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 998)
            self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 999)
            self.viewAddBeneficiary.isHidden = false
            self.scrollView.layoutIfNeeded()
        }
    }
    
    // MARK: - API CALL
    var val :Int?
    private func getTitle() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        var account = ""
        if isFromQR == "true"
        {
            account = self.beneficaryAccount!
            //            print("account format is", DataManager.instance.BankFormat)
            //            let a = (DataManager.instance.BankFormat!)
            ////
            //////
            //            let bankformat = a.substring(to: 2)
            //            let x = account
            //            val = Int(bankformat)
            ////           let c = String(x.suffix(val!))
            //            account = account.substring(from: 15)
            //            account = "0\(account)"
            //
            print("account no is", account)
        }
        else
        {
            account = self.beneficaryAccount!
        }
        
        let accountIMD = self.singleBank?.code
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/TitleFetch"
        
        if !(mobileNumberTextField.text?.isEmpty)!{
            
            self.mobileNumberTextField.text = ""
            
        }
        if !(nickNameTextField.text?.isEmpty)!{
            self.nickNameTextField.text = ""
        }
        if !(emailTextField.text?.isEmpty)!{
            self.emailTextField.text = ""
        }
        
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"account":account,"account_imd":accountIMD! ,"beneficiary_name":nickNameTextField.text!,"beneficiary_mobile":mobileNumberTextField.text!,"beneficiary_email":emailTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<TitleFetch>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<TitleFetch>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.TitleObj = Mapper<TitleFetch>().map(JSONObject: json)
                    //                self.TitleObj = response.result.value
                    if self.TitleObj?.response == 2 || self.TitleObj?.response == 1 {
                        DataManager.instance.beneficaryTitle = self.TitleObj?.account_title
                        self.updateUI()
                        if self.TitleObj?.otp_id == 0{
                            self.otpTextField.isHidden = true
                        }
                        else{
                            self.otpTextField.isHidden = false
                            self.showToast(title: "OTP has been Generated")
                            self.isFromHome = true
                        }
                        self.titleFetched = true
                    }
                    else {
                        if let messageError = self.TitleObj?.message{
                            self.showDefaultAlert(title: "", message: messageError)
                        }
                    }
                }
                else {
                    self.showAlert(title: "error", message: "Account not found" , completion: {self.navigationController?.popViewController(animated: true)
                        
                    })
                    self.payNowButton.isEnabled = false
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func payIbftFundTransfer() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let accountIMD = self.singleBank?.code
        
        if (nickNameTextField.text?.isEmpty)!{
            nickNameTextField.text = ""
        }
        if (mobileNumberTextField.text?.isEmpty)!{
            mobileNumberTextField.text = ""
        }
        if (emailTextField.text?.isEmpty)!{
            emailTextField.text = ""
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/IBFT"
        
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"from_account":self.sourceAccount!,"to_account":self.beneficaryAccount!,"amount":self.transferAmount!,"account_imd":accountIMD!,"beneficiary_name":nickNameTextField.text!,"beneficiary_mobile":mobileNumberTextField.text!,"beneficiary_email":emailTextField.text!,"purpose_of_payment":DataManager.instance.reasonForTrans!,"account_title":self.TitleObj?.account_title! ?? "no Value","benificiary_iban":self.TitleObj?.benificiary_iban! ?? "No Iban"] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<IBFTFundTransfer>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<IBFTFundTransfer>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.ibftFundObj = Mapper<IBFTFundTransfer>().map(JSONObject: json)
                //            self.ibftFundObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.ibftFundObj?.response == 2 || self.ibftFundObj?.response == 1 {
                        
                        self.navigateToDetailsVC()
                        
                    }
                    else {
                        if let message = self.ibftFundObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.ibftFundObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func addBeneCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let accountIMD = self.singleBank?.code
        
        //        if (nickNameTextField.text?.isEmpty)!{
        //            nickNameTextField.text = ""
        //        }
        //        if (mobileNumberTextField.text?.isEmpty)!{
        //            mobileNumberTextField.text = ""
        //        }
        //        if (emailTextField.text?.isEmpty)!{
        //            emailTextField.text = ""
        //        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Beneficiary"
        
        let params = ["to_account":self.beneficaryAccount!,"account_imd":accountIMD!,"beneficiary_name":nickNameTextField.text!,"beneficiary_mobile":mobileNumberTextField.text!,"beneficiary_email":emailTextField.text!,"otp_id":self.TitleObj?.otp_id ?? 0,"otp_key":self.otpTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genObj = Mapper<GenericResponse>().map(JSONObject: json)
                //            self.ibftFundObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.genObj?.response == 2 || self.genObj?.response == 1 {
                        
                        if let message = self.genObj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    else {
                        if let message = self.genObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.genObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
