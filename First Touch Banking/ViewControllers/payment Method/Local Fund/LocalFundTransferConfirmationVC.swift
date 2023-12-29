//
//  LocalFundTransferConfirmationVC.swift
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

class LocalFundTransferConfirmationVC: BaseVC {
    
    @IBOutlet weak var lblSourceAccount: UILabel!
    @IBOutlet weak var lblBeneficaryAccount: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    var sourceAccount:String?
    var beneficaryAccount:String?
    var transferAmount:String?
    var genObj:GenericResponse?
    var TitleObj:TitleFetch?
    var LocalFundObj:LocalFundsTransfer?
    var titleFetched:Bool = false

    @IBOutlet weak var lblcncl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var viewAddBeneficiary: UIView!
    @IBOutlet var btn_AddBene: UIButton!
    var addBeneficiary:Bool?
    @IBOutlet  var nickNameTextField: SkyFloatingLabelTextField!
    @IBOutlet  var mobileNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet  var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet var viewBottomButtonsUpperConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomButtonsDownConstraint: NSLayoutConstraint!

   
    static let networkManager = NetworkManager()

    @IBOutlet weak var lblsubtitle: UILabel!
    
    @IBOutlet weak var btnpaynow: UIButton!
    @IBOutlet weak var btncancel: UIButton!
    
    @IBOutlet weak var lblmaintitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        self.clearAll()
        self.getTitle()
        self.updateUI()
        
        addBeneficiary = true
        btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true

        // Do any additional setup after loading the view.
    }

    func ChangeLanguage()
    {
        lblmaintitle.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblsubtitle.text = "Local Funds Transfer Confirmation".addLocalizableString(languageCode: languageCode)
        lblcncl.text = "CANCEL".addLocalizableString(languageCode: languageCode)
        btnpaynow.setTitle("PayNow".addLocalizableString(languageCode: languageCode), for: .normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
        
    }
    
    // MARK: - Utility Methods
    
    private func clearAll(){
        
        self.lblSourceAccount.text = ""
        self.lblBeneficaryAccount.text = ""
        self.lblAmount.text = ""
        self.lblAccountTitle.text = ""
        
    }
    
    private func updateUI(){
       
        
        if let account = sourceAccount{
            self.lblSourceAccount.text = account
        }
        if let beneAccount = beneficaryAccount{
            self.lblBeneficaryAccount.text = beneAccount
        }
        if let Tamount = transferAmount{
            self.lblAmount.text = "PKR \(Tamount).00"
        }
       if  isFromQR == "true"
        {
           self.lblAccountTitle.text = DataManager.instance.accountTitle
           self.nickNameTextField.text = DataManager.instance.accountTitle
        }
        else{
            self.lblAccountTitle.text = DataManager.instance.beneficaryTitle
            self.nickNameTextField.text = DataManager.instance.beneficaryTitle
        }
        
    }
    
    private func navigateToDetailsVC(){
        let localFundsDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundsTransferDetailsVC") as! LocalFundsTransferDetailsVC
        
        localFundsDetailsVC.sourceAccount = self.sourceAccount
        localFundsDetailsVC.beneficaryAccount = self.beneficaryAccount
        localFundsDetailsVC.beneficaryAccountTitle = DataManager.instance.beneficaryTitle
        localFundsDetailsVC.transferAmount = self.transferAmount
        localFundsDetailsVC.TransRefNumber = self.LocalFundObj?.stan
        localFundsDetailsVC.TransTime = self.LocalFundObj?.tran_time
        
        self.navigationController!.pushViewController(localFundsDetailsVC, animated: true)
    }
    
    // MARK: - Action Method
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
       
        self.payLocalFundTransfer()
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
//            addbeneificiary
           
        }
    }
    var singleBank : SingleBank?
//    private func addBeneCall() {
//
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//
//        showActivityIndicator()
//
//        let accountIMD = self.singleBank?.code
//
////        if (nickNameTextField.text?.isEmpty)!{
////            nickNameTextField.text = ""
////        }
////        if (mobileNumberTextField.text?.isEmpty)!{
////            mobileNumberTextField.text = ""
////        }
////        if (emailTextField.text?.isEmpty)!{
////            emailTextField.text = ""
////        }
//
//        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Beneficiary"
//
//        let params = ["to_account":self.beneficaryAccount!,"account_imd":accountIMD!,"beneficiary_name":nickNameTextField.text!,"beneficiary_mobile":mobileNumberTextField.text!,"beneficiary_email":emailTextField.text!,"otp_id":self.TitleObj?.otp_id ?? 0,"otp_key":self.otpTextField.text!] as [String : Any]
//
//        let header = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
//
//        print(params)
//        print(compelteUrl)
//
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
////        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
//
//            self.hideActivityIndicator()
//
//            self.genObj = response.result.value
//            if response.response?.statusCode == 200 {
//
//                if self.genObj?.response == 2 || self.genObj?.response == 1 {
//
//                    if let message = self.genObj?.message{
//                        self.showAlert(title: "", message: message, completion: {
//                            self.navigationController?.popToRootViewController(animated: true)
//                        })
//                    }
//
//
//                }
//                else {
//                    if let message = self.genObj?.message{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
//                }
//            }
//            else {
//                if let message = self.genObj?.message{
//                    self.showDefaultAlert(title: "", message: message)
//                }
//                print(response.result.value)
//                print(response.response?.statusCode)
//            }
//        }
//    }
//

    // MARK: - API CALL
    
    private func getTitle() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        
        let account = self.beneficaryAccount
        let accountIMD = "220557"
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/TitleFetch"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"account":account!,"account_imd":accountIMD] as [String : Any]
        
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
                        self.titleFetched = true
                    }
                    else {
                        if let message = self.TitleObj?.message{
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                }
                else {
                    self.showAlert(title: "error", message: "Account not found" , completion: {self.navigationController!.popViewController(animated: true)
                    })
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }

            }
        }
    }
    
    private func payLocalFundTransfer() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/FundsTransfer"
        
        if (mobileNumberTextField.text?.isEmpty)!{
            self.mobileNumberTextField.text = ""
        }
        if (nickNameTextField.text?.isEmpty)!{
            self.nickNameTextField.text = ""
        }
        if (emailTextField.text?.isEmpty)!{
            self.emailTextField.text = ""
        }
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"from_account":self.sourceAccount!,"to_account":self.beneficaryAccount!,"amount":self.transferAmount!,"account_imd":"220557" ,"beneficiary_name":nickNameTextField.text!,"beneficiary_mobile":mobileNumberTextField.text!,"beneficiary_email":emailTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<LocalFundsTransfer>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<LocalFundsTransfer>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.LocalFundObj = Mapper<LocalFundsTransfer>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.LocalFundObj?.response == 2 || self.LocalFundObj?.response == 1 {
                        
                        self.navigateToDetailsVC()
                        
                    }
                    else {
                        if let message = self.LocalFundObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.LocalFundObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    
                    //                print(response.result.value)
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

}
