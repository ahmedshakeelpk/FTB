//
//  LocalFundsTransferVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 13/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SkyFloatingLabelTextField
import ObjectMapper


class LocalFundsTransferVC: BaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var lblsubtitle: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet var dropDownAccounts: UIDropDown!
    var arrAccountList : [String]?
    var accountsObj:Accounts?
    var sourceAccount:String?
    @IBOutlet weak var accountNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var ammountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lblCurrentBalance: UILabel!
    var isFromHome:Bool = false
    var beneficiaryAccount:String?
    static let networkManager = NetworkManager()
    var isFromQuickPay:Bool = false
    var balanceObj:BalanceInquiry?
    
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnSubmit: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    //    from QR
    var Transaction_amount : String?
    var Purposeof_Transaction: String?
    var Transation_Scheme : String?
    var Expiry_DatefromQR : String?
    var User_IBAN : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguage()
        if self.isFromQuickPay == true{
            self.accountNumberTextField.isUserInteractionEnabled = false
        }
        if self.isFromHome == true{
            self.getAccounts()
        }
        if isFromQR == "true"
        {
            self.getAccounts()
            accountNumberTextField.text = User_IBAN
            ammountTextField.text = Transaction_amount
            
        }
        else{
            self.getAccounts()
            updateUI()
        }
        //        if isFromQR == "true"
        //        {
        //            dropdownType.text = Transation_Scheme
        //            dropdownType.isUserInteractionEnabled = false
        //            lblmobileno.text = "Enter IBAN"
        //            mobilenoTextfield.text =   User_IBAN
        //            dropdownreason.text = Purposeof_Transaction
        //            dropdownreason.isUserInteractionEnabled = false
        //            amounttextfield.text = Transaction_amount
        //            amounttextfield.isUserInteractionEnabled = false
        //            Contactbtn.isHidden = true
        //            AliasType = "IBAN"
        //        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func Changelanguage()
    {
        lblMain.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblsubtitle.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblCancel.text = "CANCEL".addLocalizableString(languageCode: languageCode)
        btnSubmit.text = "SUBMIT".addLocalizableString(languageCode: languageCode)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Utility Methods
    
    private func updateUI(){
        if let beneAccount = self.beneficiaryAccount{
            self.accountNumberTextField.text = beneAccount
        }
    }
    
    //MARK: - DropDown
    
    private func methodDropDownAccounts(Accounts:[String]) {
        
        self.dropDownAccounts.placeholder = Accounts[0]
        self.dropDownAccounts.tableHeight = 80.0
        self.dropDownAccounts.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.sourceAccount = Accounts[0]
        self.dropDownAccounts.options = Accounts
        self.dropDownAccounts.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.sourceAccount = option
            
        })
    }
    
    //MARK: - UITextField Delegate Methods
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        
        if textField == ammountTextField
        {
            let rep = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return rep.count == 0 || Double(rep) != nil
        }
        
        if textField == accountNumberTextField
        {
            return newLength <= 16 // Bool
        }
        else
        {
            return newLength <= 10
        }
    }
    
    // MARK: - Action Method
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func submitPressed(_ sender: Any) {
        
        //        if (accountNumberTextField.text?.count)! < 16 {
        //            self.showToast(title:"Please enter valid account number")
        //            return
        //        }
        if ammountTextField.text?.count == 0 {
            return
        }
        if Double(ammountTextField.text!)! < 1 || Double(ammountTextField.text!)! > 500000 {
            self.showToast(title: "Invalid Amount")
            return
        }
        //        if let balanceValue = DataManager.instance.currentBalance {
        //            if (ammountTextField.text)! > String(Float(balanceValue)!) {
        //                self.showToast(title: "Amount Exceed")
        //                return
        //            }
        //        }
        self.navigateToConfirmation()
    }
    
    // MARK: - Utility Method
    
    private func navigateToConfirmation(){
        
        let localFundConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferConfirmationVC") as! LocalFundTransferConfirmationVC
        localFundConfirmVC.sourceAccount = self.sourceAccount
        localFundConfirmVC.beneficaryAccount = self.accountNumberTextField.text
        localFundConfirmVC.transferAmount = self.ammountTextField.text
        
        
        self.navigationController!.pushViewController(localFundConfirmVC, animated: true)
    }
    
    // MARK: - API CALL
    
    private func getBalanceInquiry() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/AccountBalanceInquiry"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!] as [String : Any]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            response in
            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<BalanceInquiry>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<BalanceInquiry>) in
            
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.balanceObj = Mapper<BalanceInquiry>().map(JSONObject: json)
                //            self.fundsTransSuccessObj = response.result.value
//                self.balanceObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.balanceObj?.response == 0
                    {
                        if let message = self.balanceObj?.message {
                            //                        self.showAlert(title: "", message: message, completion: nil)
                        }
                        
                    }
                    
                    if self.balanceObj?.response == 2 || self.balanceObj?.response == 1 {
                        DataManager.instance.currentBalance = self.balanceObj?.account_curr_balance
                    }
                    if let balanceValue = DataManager.instance.currentBalance {
                        self.lblCurrentBalance.text = "Balance: PKR \(balanceValue)"
                    }
                    else {
                        if let message = self.balanceObj?.message {
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                }
                else {
                    
                    if self.balanceObj?.response == 0
                    {
                        if let message = self.balanceObj?.message {
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    //                if let message = self.balanceObj?.message {
                    //                    self.showAlert(title: "", message: message, completion: {
                    ////                        self.logoutUser()
                    //                    })
                    //                }
                    else{
                        self.showAlert(title: "", message: "Host not responding. Please try again", completion: nil)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func getAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            response in
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response {
        response in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<Accounts>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.accountsObj = Mapper<Accounts>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
//                    self.accountsObj = response.result.value
                    if self.accountsObj?.response == 2 || self.accountsObj?.response == 1 {
                        
                        self.arrAccountList = self.accountsObj?.stringAccounts
                        //                    self.currentID = self.issueListObj?.issuesList?[0].id
                        self.methodDropDownAccounts(Accounts: (self.arrAccountList)!)
                        self.getBalanceInquiry()
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    
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
}


//NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response {
//    response in
//
//    self.hideActivityIndicator()
//    if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) {
//        self.fundsTransSuccessObj = Mapper<Accounts>().map(JSONObject: json)
//        //            self.fundsTransSuccessObj = response.result.value
//        self.balanceObj = response.result.value
//        if response.response?.statusCode == 200 {
//
//        }
//        else {
//        }
//    }
//}

