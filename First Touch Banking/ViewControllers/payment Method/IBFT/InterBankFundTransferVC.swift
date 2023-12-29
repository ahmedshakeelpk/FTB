//
//  InterBankFundTransferVC.swift
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
class InterBankFundTransferVC: BaseVC , UITextFieldDelegate{
    var bankFormatCount : String?
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet var dropDownAccounts: UIDropDown!
    @IBOutlet var dropDownBankNames: UIDropDown!
    @IBOutlet var dropDownReasons: UIDropDown!
    var arrAccountList : [String]?
    var arrBanksList : [String]?
    var arrReasonsList : [String]?
    var accountsObj:Accounts?
    var banksObj:BankNames?
    var banksList = [SingleBank]()
    var reasonObj:GetReaons?
    var arrRaastList = [rastmodelclass]()
    var reasonsList = [SingleReason]()
    var sourceAccount:String?
    var sourceReasonForTrans:String?
    var sourceBank:String?
    var get_Bank_from_Sccaner = ""
    var imdCode:String?
    //    from QR
    var Transaction_amount : String?
    var Purposeof_Transaction: String?
    var Transation_Scheme : String?
    var Expiry_DatefromQR : String?
    var User_IBAN : String?
    @IBOutlet weak var accountNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var ammountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var lblbeneDesc : UILabel!
    var isFromHome:Bool = false
    var varBeneAccountNum:String?
    static let networkManager = NetworkManager()
    var isFromQuickPay:Bool = false
    var balanceObj:BalanceInquiry?
    var isFromDonations:Bool = false
    var transConsentObj : TransactionConsent?
    var genericResponse:GenericResponse?
    
    @IBOutlet weak var lblReasonsTitle : UILabel!
    @IBOutlet weak var lblTransferAmountTitle : UILabel!
    @IBOutlet weak var lblMainTitle : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubmit: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    var arrIbftBene = [SingleBeneficiary]()
    func changeLanguage()
    {
        lblCancel.text = "CANCEL".addLocalizableString(languageCode: languageCode)
        //        lblSubmit.text = "SUBMIT".addLocalizableString(languageCode: languageCode)
        lblMainTitle.text = "IBFT".addLocalizableString(languageCode: languageCode)
        //        btnsubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        lblSubmit.text = "SUBMIT".addLocalizableString(languageCode: languageCode)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountNumberTextField.delegate = self
        ammountTextField.delegate = self
        accountNumberTextField.keyboardType = .asciiCapable
        print("self.get_Bank_from_Sccaner", self.get_Bank_from_Sccaner)
        changeLanguage()
        if self.isFromQuickPay == true{
            self.accountNumberTextField.isUserInteractionEnabled = false
        }
        if isFromQR == "true"
        {
            getAccounts()
            accountNumberTextField.text = User_IBAN ?? ""
            ammountTextField.text = Transaction_amount
            DataManager.instance.reasonForTrans = Transation_Scheme
            
        }
        else
        {
            self.updateUIBene()
            self.getAccounts()
        }// Do any additional setup after loading the view.
        
        print("\(arrIbftBene)")
        accountNumberTextField .addTarget(self, action: #selector(ibanTextFieldEditingChanged(_:)), for: .editingChanged)
        
    }
    @objc func ibanTextFieldEditingChanged(_ textField: UITextField) {
        if isValid24DigitIBAN(accountNumberTextField.text!) {
            print("Valid 24-digit IBAN")
            
        } else {
            print("Invalid 24-digit IBAN")
        }
        //            let inputText = textField.text ?? ""
        //
        //            // Regular expression pattern for IBAN validation
        //            let ibanPattern = "^[A-Z0-9]{8,}$"  // Adjust the length as needed
        //
        //            let ibanPredicate = NSPredicate(format: "SELF MATCHES %@", ibanPattern)
        //
        //            if ibanPredicate.evaluate(with: inputText) {
        //               return
        ////                validationStatusLabel.textColor = .green
        //            } else {
        //
        ////                validationStatusLabel.textColor = .red
        //            }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUIBene(){
        
        if isFromHome == true{
            
            self.ammountTextField.isHidden = true
            self.dropDownReasons.isHidden = true
            self.lblCurrentBalance.isHidden = true
            self.lblReasonsTitle.isHidden = true
            self.lblTransferAmountTitle.isHidden = true
            self.lblMainTitle.text = "Add Beneficary".addLocalizableString(languageCode: languageCode)
            self.lblTitle.text = "Add Beneficary".addLocalizableString(languageCode: languageCode)
            
        }
        //
        
    }
    
    
    var form : String?
    private func updateUI(){
        let title = self.sourceBank
        for aBank in self.banksList {
            if aBank.name == title {
                
                if let bankDescription = aBank.description{
                    let str = bankDescription
                    let replaced = str.replacingOccurrences(of: "_", with: "\n")
                    self.lblbeneDesc.text = replaced
                }
                
                if let bankForamt = aBank.format {
                    accountNumberTextField.delegate = self
                    if ((bankForamt == "11") || (bankForamt == "13") || (bankForamt == "14") || (bankForamt == "16") || (bankForamt == "17") || (bankForamt == "15_11"))
                        
                    {
                        bankFormatCount = bankForamt
                        print("bank format", bankFormatCount?.count)
                        var b = aBank.name
                        print("bank name", b)
                        
                    }
                    
                    //                    form = aBank.format
                    if bankForamt.contains("_"){
                        let replaced = bankForamt.replacingOccurrences(of: "_", with: " or ")
                        //                        self.accountNumberTextField.placeholder = "Please enter \(replaced) digit Account Number"
                        self.accountNumberTextField.placeholder = "Please Enter Account Number"
                    }
                    else {
                        self.accountNumberTextField.placeholder = "Please Enter Account Number"
                        //                        self.accountNumberTextField.placeholder = "Please enter \(bankForamt) digit Account Number"
                    }
                }
            }
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
    private func methodDropDownBanks(Banks:[String]) {
        
        // self.dropDownBankNames.placeholder = Banks[0]
        if self.isFromHome == true{
            self.dropDownBankNames.placeholder = "Select Bank"
        }
        else{
            self.dropDownBankNames.placeholder = Banks[0]
        }
        
        self.dropDownBankNames.tableHeight = 250.0
        // self.sourceBank = Banks[0]
        self.updateUI()
        self.dropDownBankNames.options = Banks
        //        if isFromQR == "true"
        //        {
        //            dropDownBankNames.options = self.sourceBank
        //        }
        //        else
        //        {
        self.dropDownBankNames.didSelect(completion: { [self]
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            accountNumberTextField.text = ""
            self.sourceBank = option
            if isFromQR == "true"
            {
                self.sourceBank = get_Bank_from_Sccaner
                
            }
            else
            {
                self.updateUI()
            }
            
        })
        //        }
        
    }
    
    private func methodDropDownReasons(Reasons:[String]) {
        
        
        if self.isFromHome == true {
            self.dropDownReasons.placeholder = "Select Reasons"
        }
        else if self.isFromDonations == true {
            self.dropDownReasons.placeholder = Reasons[0]
        }
        else if self.isFromQuickPay == true{
            self.dropDownReasons.placeholder = "Select Reasons"
        }
        else{
            self.dropDownReasons.placeholder = Reasons[0]
        }
        
        self.dropDownReasons.tableHeight = 85.0
        //      self.dropDownAccounts.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //     self.sourceAccount = Reasons[0]
        self.dropDownReasons.options = Reasons
        self.dropDownReasons.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.sourceReasonForTrans = option
            
            let code = self.sourceReasonForTrans
            for aCode in self.reasonsList {
                if aCode.description == code {
                    DataManager.instance.reasonForTrans = aCode.code
                }
            }
        })
    }
    
    
    private func popUpConsent(){
        
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to activate IBFT Services".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Ok".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            //            self.getOTPInitiate()
            let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
            OTPVerifyVC.mainTitle = "Enter OTP for Transaction Consent".addLocalizableString(languageCode: languageCode)
            OTPVerifyVC.ForTransactionConsent = true
            OTPVerifyVC.sourceAccount = self.sourceAccount
            self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
            print("Handle Ok logic here")
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(consentAlert, animated: true, completion: nil)
    }
    
    //MARK: - UITextField Delegate Methods
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        
        //        only allow Alphanumeric
        let alphanumericCharacterSet = CharacterSet.alphanumerics
        
        for scalar in string.unicodeScalars {
            if !alphanumericCharacterSet.contains(scalar) {
                return false // Reject the input
            }
        }
        let allowedCharacters = string
        let characterSet = CharacterSet(charactersIn: allowedCharacters)
        
        if string.rangeOfCharacter(from: characterSet.inverted) != nil {
            return false // Disallow input of invalid characters
        }
        if textField == ammountTextField
        {
            let rep = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return rep.count == 0 || Double(rep) != nil
        }
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == accountNumberTextField{
            if bankFormatCount == "11" || bankFormatCount == "15_11"
            {
                return newLength <= 11
            }
            
            else if bankFormatCount == "13"
            {
                return newLength <= 13
            }
            else if bankFormatCount == "14"
            {
                return newLength <= 14
            }
            else if bankFormatCount == "16"
            {
                return newLength <= 16
            }
            else if bankFormatCount == "17"
            {
                return newLength <= 17
            }
            else
            {
                return newLength <= 24
            }
            
        }
        
        
        else{
            return newLength <= 10
        }
        return true
        
    }
    
    func isValid24DigitIBAN(_ iban: String) -> Bool {
        // Remove spaces and convert to uppercase
        let cleanedIBAN = iban.replacingOccurrences(of: " ", with: "").uppercased()
        accountNumberTextField.text = cleanedIBAN
        
        // Check if the IBAN length is exactly 24 characters
        if cleanedIBAN.count != 24 {
            return false
        }
        
        // Replace letters with digits
        var numericIBAN = ""
        for character in cleanedIBAN {
            if let asciiValue = character.asciiValue {
                if asciiValue >= 65 && asciiValue <= 90 {
                    // Convert letters to digits (A=10, B=11, ..., Z=35)
                    let digit = Int(asciiValue - 55)
                    numericIBAN += String(digit)
                } else {
                    // Keep digits as they are
                    numericIBAN += String(character)
                }
            }
        }
        if let numericValue = Int(numericIBAN) {
            return numericValue % 97 == 1
        }
        
        return false
    }
    
    
    // MARK: - Action Method
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
        
        let code = self.sourceReasonForTrans
        for aCode in self.reasonsList {
            if aCode.description == code {
                DataManager.instance.reasonForTrans = aCode.code
            }
        }
        if isFromQR == "true"
        {
            
            //            self.navigateToConfirmation()
            
            
            
        }
        else
        {
            if self.sourceBank == nil{
                self.showDefaultAlert(title: "Alert", message: "Kindly select Bank")
                return
            }
        }
        
        if self.accountNumberTextField.text == nil || self.accountNumberTextField.text == ""{
            self.showDefaultAlert(title: "Alert", message: "Kindly enter account number")
            return
        }
        if isFromHome == true{
            self.ammountTextField.text = "5"
        }
        else{
            if ammountTextField.text?.count == 0 {
                self.showDefaultAlert(title: "", message: "Enter Amount")
                return
            }
            
            if DataManager.instance.reasonForTrans == nil || (DataManager.instance.reasonForTrans?.isEmpty)!{
                self.showToast(title: "Please select reason")
                return
            }
        }
        
        if ammountTextField.text?.count == 0 {
            self.showDefaultAlert(title: "", message: "Enter Amount")
            return
        }
        //        if DataManager.instance.reasonForTrans == nil || (DataManager.instance.reasonForTrans?.isEmpty)!{
        //            self.showToast(title: "Please select reason")
        //            return
        //        }
        
        
        
        if Double(ammountTextField.text!)! < 1 || Double(ammountTextField.text!)! > 250000 {
            self.showToast(title: "Invalid Amount")
            return
        }
        
        
        //        if let balanceValue = DataManager.instance.currentBalance {
        //            if (ammountTextField.text)! > String(Float(balanceValue)! - Float(15)) {
        //                self.showToast(title: "Amount Exceed")
        //                return
        //            }
        //        }
        
        
        for aBene in (arrIbftBene){
            //            if aBene.account == self.accountNumberTextField.text{
            //                self.showToast(title: "Already Exists")
            //                return
            //            }
            
            let title = self.sourceBank
            for aBank in self.banksList {
                if aBank.name == title {
                    if aBank.code == aBene.beneficiary_code && aBene.account == self.accountNumberTextField.text {
                        self.showToast(title: "Already Exists")
                        return
                    }
                }
            }
            
            //            if aBene.beneficiary_code == self.imdCode {
            //                self.showToast(title: "Already Exists")
            //                return
            //            }
        }
        self.navigateToConfirmation()
    }
    
    // MARK: - Utility Method
    
    private func navigateToConfirmation(){
        
        let ibftFundConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "InterBankFundTransferConfirmationVC") as! InterBankFundTransferConfirmationVC
        ibftFundConfirmVC.sourceAccount = self.sourceAccount
        ibftFundConfirmVC.beneficaryAccount = self.accountNumberTextField.text
        ibftFundConfirmVC.transferAmount = self.ammountTextField.text
        ibftFundConfirmVC.beneficaryBankName = self.sourceBank
        
        if isFromHome == true{
            ibftFundConfirmVC.isFromHome = true
        }
        else{
            ibftFundConfirmVC.isFromHome = false
        }
        
        let title = self.sourceBank
        for aBank in self.banksList {
            if aBank.name == title {
                ibftFundConfirmVC.singleBank = aBank
            }
            
        }
        self.navigationController!.pushViewController(ibftFundConfirmVC, animated: true)
    }
    
    // MARK: - API CALL
    
    
    private func getTransactionConsent() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/\(self.sourceAccount!)/TransactionConsent"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<TransactionConsent>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<TransactionConsent>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.transConsentObj = Mapper<TransactionConsent>().map(JSONObject: json)
                    
                    if self.transConsentObj?.response == 0 {
                        self.popUpConsent()
                    }
                }
                else {
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                    if let messageErrorTrans = self.transConsentObj?.message{
                        self.showDefaultAlert(title: "", message: messageErrorTrans)
                    }
                }
            }
        }
    }
    
    //    private func sendTransactionConsent() {
    //
    //        if !NetworkConnectivity.isConnectedToInternet(){
    //            self.showToast(title: "No Internet Available")
    //            return
    //        }
    //
    //        showActivityIndicator()
    //
    //        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/TransactionConsent"
    //
    //        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"AccountNumber":self.sourceAccount!,"TransactionConsent":1] as [String : Any]
    //
    //        let header = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
    //
    //        print(params)
    //        print(compelteUrl)
    //
    //        //NetworkManager.sharedInstance.enableCertificatePinning()
    //
    //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
    //
    //            self.hideActivityIndicator()
    //
    //            self.genericResponse = response.result.value
    //            if response.response?.statusCode == 200 {
    //
    //                if self.genericResponse?.response == 2 || self.genericResponse?.response == 1 {
    //
    //                }
    //                else {
    //                    if let message = self.genericResponse?.message{
    //                        self.showDefaultAlert(title: "", message: message)
    //                    }
    //                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
    //                }
    //            }
    //            else {
    //                if let message = self.genericResponse?.message{
    //                    self.showDefaultAlert(title: "", message: message)
    //                }
    //                print(response.result.value)
    //                print(response.response?.statusCode)
    //            }
    //        }
    //    }
    
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
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<BalanceInquiry>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<BalanceInquiry>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.balanceObj = Mapper<BalanceInquiry>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.balanceObj?.response == 0
                    {
                        if let message = self.balanceObj?.message {
                            //                        self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                    
                    if self.balanceObj?.response == 2 || self.balanceObj?.response == 1 {
                        
                        
                        if let message = self.balanceObj?.message {
                            //                        self.showAlert(title: "", message: message, completion: nil)
                        }
                        DataManager.instance.currentBalance = self.balanceObj?.account_curr_balance
                    }
                    if let balanceValue = DataManager.instance.currentBalance {
                        
                        
                        
                        self.lblCurrentBalance.text = "Balance : PKR \(balanceValue)"
                        self.getReasonsForTrans()
                    }
                    else {
                        if let message = self.balanceObj?.message {
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                }
                else {
                    if let message = self.balanceObj?.message {
                        self.showAlert(title: "", message: message, completion: {
                            
                        })
                    }
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
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get,  encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { [self] (response: DataResponse<Accounts>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<Accounts>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.accountsObj = Mapper<Accounts>().map(JSONObject: json)
                    if self.accountsObj?.response == 2 || self.accountsObj?.response == 1 {
                        
                        self.arrAccountList = self.accountsObj?.stringAccounts
                        //                    self.currentID = self.issueListObj?.issuesList?[0].id
                        self.methodDropDownAccounts(Accounts: (self.arrAccountList)!)
                        if isFromQR == "true"
                        {
                            //                        self.getBalanceInquiry()
                            self.getBankNames()
                        }
                        
                        else
                        {
                            self.getBankNames()
                        }
                        
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
    
    private func getBankNames() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/IBFT/Companies"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<BankNames>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BankNames>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.banksObj = Mapper<BankNames>().map(JSONObject: json)
                    
                    if self.banksObj?.response == 2 || self.banksObj?.response == 1 {
                        if let banks = self.banksObj?.singleBank{
                            self.banksList = banks
                        }
                        self.arrBanksList = self.banksObj?.stringBanks
                        if self.isFromHome == true{
                            self.methodDropDownBanks(Banks: self.arrBanksList!)
                        }
                        else{
                            if isFromQR == "true"
                            {
                                
                                for aBank in self.banksList {
                                    if let bankForamt = aBank.format
                                    {
                                        self.form = (aBank.format!)
                                        DataManager.instance.BankFormat = (self.form!)
                                    }
                                }
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Advans Micro Finance Bank LTD", oneLinkCode: "505895", rastCode: "" , format: self.form!))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Al Baraka Islamic Bank Limited", oneLinkCode: "639530", rastCode: "AIIN", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "Allied Bank Limited", oneLinkCode: "589430", rastCode: "ABPA", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Apna Microfinance Bank", oneLinkCode: "581862", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Askari Commercial Bank Limited", oneLinkCode: "603011", rastCode: "ASCM", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Bank AL Habib Limited", oneLinkCode: "627197", rastCode: "BAHL", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Bank Alfalah Limited", oneLinkCode: "627100", rastCode: "ALFH", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Bank of Punjab", oneLinkCode: "623977", rastCode: "BPUN", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Bank of Khyber", oneLinkCode: "627618", rastCode: "KHYB", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "BankIslami Pakistan Limited", oneLinkCode: "639357", rastCode: "BKIP", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Burj Bank Limited", oneLinkCode: "604786", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Citi Bank", oneLinkCode: "508117", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Dubai Islamic Bank Pakistan Limited", oneLinkCode: "428273", rastCode: "DUIB", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "FINCA Microfinance Bank", oneLinkCode: "502841", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Faysal Bank Limited", oneLinkCode: "601373", rastCode: "FAYS", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "First Women Bank", oneLinkCode: "628138", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Habib Metropolitan Bank Limited", oneLinkCode: "627408", rastCode: "MPBL", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "HBL/KONNECT", oneLinkCode: "600648", rastCode: "HABB", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "ICBC", oneLinkCode: "621464", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Easypaisa-Telenor Bank", oneLinkCode: "639390", rastCode: "TMFB", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "JS Bank Limited", oneLinkCode: "603733", rastCode: "JSBL", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "MCB Bank Limited", oneLinkCode: "589388", rastCode: "MUCB", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "MCB Islamic Banking", oneLinkCode: "507642", rastCode: "MCIB", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Meezan Bank Limited", oneLinkCode: "627873", rastCode: "MEZN", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "NIB Bank Limited", oneLinkCode: "999100", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "National Bank of Pakistan", oneLinkCode: "958600", rastCode: "NBPB", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "NRSP Bank/ForiCash", oneLinkCode: "586010", rastCode: "NRSP", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "SAMBA", oneLinkCode: "606101", rastCode: "SAMB", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Silk Bank", oneLinkCode: "627544", rastCode: "SAUD", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "Sindh Bank", oneLinkCode: "505439", rastCode: "SIND", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Soneri Bank Limited", oneLinkCode: "786110", rastCode: "SONE", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Standard Chartered Bank", oneLinkCode: "627271", rastCode: "SCBL", format: ""))
                                
                                
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Summit Bank", oneLinkCode: "604781", rastCode: "SUMB", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "UBank/UPaisa", oneLinkCode: "581886", rastCode: "UMBL", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Mobilink Bank/JazzCash", oneLinkCode: "585953", rastCode: "JCMA", format: self.form!))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "United Bank Limited", oneLinkCode: "588974", rastCode: "UNIL", format: ""))
                                
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "SME Bank Limited", oneLinkCode: "604889", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Khushhali Microfinance Bank", oneLinkCode: "220563", rastCode: "KHBL", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "NBP Fund Management", oneLinkCode: "220582", rastCode: "", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Zarai Taraqiati Bank Limited", oneLinkCode: "220564", rastCode: "", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "CENTRAL DEPOSITORY CO. OF PAKSITAN", oneLinkCode: "", rastCode: "CDCP", format: ""))
                                
                                self.arrRaastList.append(rastmodelclass(bankname: "Industrial and Commercial Bank Of China Ltd", oneLinkCode: "", rastCode: "ICBK", format: ""))
                                self.arrRaastList.append(rastmodelclass(bankname: "State Bank Of Pakistan", oneLinkCode: "", rastCode: "CLIA", format: ""))
                                
                                
                                
                                for each in self.arrRaastList
                                {
                                    if  each.rastCode ==  "\(self.get_Bank_from_Sccaner)"
                                    {
                                        self.get_Bank_from_Sccaner = each.bankname
                                        print("get_Bank_from_Sccaner", self.get_Bank_from_Sccaner)
                                        self.sourceBank = self.get_Bank_from_Sccaner
                                        self.methodDropDownBanks(Banks:[self.sourceBank ?? ""])
                                        
                                        self.updateUI()
                                    }
                                }
                                
                            }
                            else{
                                self.methodDropDownBanks(Banks:[self.sourceBank ?? ""])
                                self.accountNumberTextField.text = self.varBeneAccountNum
                                
                            }
                        }
                        self.getBalanceInquiry()
                        //                        self.getBalanceInquiry()
                        //                        self.getBalanceInquiry()
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                }
            }
        }
    }
    
    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/PurposeOfTransaction"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GetReaons>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetReaons>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.reasonObj = Mapper<GetReaons>().map(JSONObject: json)
                    if self.reasonObj?.response == 2 || self.reasonObj?.response == 1 {
                        if let reasonCodes = self.reasonObj?.singleReason{
                            self.reasonsList = reasonCodes
                        }
                        
                        self.arrReasonsList = self.reasonObj?.stringReasons
                        
                        if self.isFromDonations == true{
                            self.methodDropDownReasons(Reasons:[self.sourceReasonForTrans!])
                        }
                        else{
                            
                            self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                        }
                        //      self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                        self.getTransactionConsent()
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    
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
class rastmodelclass{
    var bankname : String
    var oneLinkCode : String
    var rastCode : String
    var format : String
    init(bankname : String , oneLinkCode : String , rastCode : String , format : String){
        self.rastCode = rastCode
        self.oneLinkCode = oneLinkCode
        self.bankname = bankname
        self.format = format
    }
    
}

extension Formatter {
    static let currency: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }()
}
