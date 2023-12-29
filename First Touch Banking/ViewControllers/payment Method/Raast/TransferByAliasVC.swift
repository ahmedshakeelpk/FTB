//
//  TransferByAliasVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 31/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS
import ObjectMapper
var mobiletextfiledvalue : String?
var PurpseReasonId : String?
var AliasSelectUserText = ""
var AliasSelect = ""
var AliasType : String?
var isFromQR : String?

class TransferByAliasVC: BaseVC ,UITextFieldDelegate{
    var sourcAcc : String?
    var SType : String?
    var AccNo : String?
    var IBAN : String?
    var IsFromRaast : String?
    var TransationByAliasModelobj : TransationByAliasModel?
    var reasonObj:RaastReason?
    var accountsObj:Accounts?
    var sourceAccount:String?
    var selectedlist : String?
    var selectedReason : String?
    //    from QR
    var Transaction_amount : String?
    var Purposeof_Transaction: String?
    var Transation_Scheme : String?
    var Expiry_DatefromQR : String?
    var User_IBAN : String?
    
    
    
    
    
    
    
    private let contactPicker = CNContactPickerViewController()
    
    
    
    @IBOutlet weak var Contactbtn: UIButton!
    
    
    var arrAccountList : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Contactbtn.isHidden = true
        amounttextfield.delegate = self
        mobilenoTextfield.delegate = self
        getcnic()
        self.DropdownSourceAccount.text = DataManager.instance.accountno!
        self.lblmobileno.text = "Enter Mobile No".addLocalizableString(languageCode: languageCode)
        lblMain.text = "Transfer By Raast ID".addLocalizableString(languageCode: languageCode)
        lblSourceAccount.text = "Source Account".addLocalizableString(languageCode: languageCode)
        lblType.text = "Select Type".addLocalizableString(languageCode: languageCode)
        lblTransferAmount.text = "Transfer Amount".addLocalizableString(languageCode: languageCode)
        lblReason.text = "Reason".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        dropdownreason.placeholder = "Reason".addLocalizableString(languageCode: languageCode)
        btnConfirm.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        if isFromQR == "true"
        {
            dropdownType.text = Transation_Scheme
            dropdownType.isUserInteractionEnabled = false
            lblmobileno.text = "Enter IBAN"
            mobilenoTextfield.text =   User_IBAN
            //            dropdownreason.text = Purposeof_Transaction
            //            dropdownreason.isUserInteractionEnabled = false
            amounttextfield.text = Transaction_amount
            amounttextfield.isUserInteractionEnabled = false
            Contactbtn.isHidden = true
            AliasType = "IBAN"
        }
        
        //        this senrio is based on mobile No
        if IsFromRaast == "true"{
            if AliasType == IBAN
            {
                AliasType = "IBAN"
                //                if AccNo == nil{
                //                    dropdownType.text = "IBAN"
                //                }
                //                else
                //                {
                //                    dropdownType.text = AccNo
                //                }
                Contactbtn.isHidden = false
                dropdownType.text = AccNo
                dropdownType.isUserInteractionEnabled = false
                mobilenoTextfield.isUserInteractionEnabled = false
                mobilenoTextfield.text = sourcAcc
                amounttextfield.placeholder = "Enter amount (1.00- 50000)".addLocalizableString(languageCode:languageCode)
                amounttextfield.isUserInteractionEnabled = true
                //                getAccounts()
                self.amounttextfield.delegate = self
                self.mobilenoTextfield.delegate = self
                methodDropDownInquiries()
                getReasonsForTrans()
                
            }
            else{
                AliasType = "MOBILE"
                //            AliasType = AccNo
                //            DropdownSourceAccount.text =
                
                dropdownType.text = AccNo
                dropdownType.isUserInteractionEnabled = false
                mobilenoTextfield.isUserInteractionEnabled = true
                mobilenoTextfield.text = sourcAcc
                amounttextfield.placeholder = "Enter amount (1.00- 500000)".addLocalizableString(languageCode:languageCode)
                
                //                getAccounts()
                
                self.amounttextfield.delegate = self
                self.mobilenoTextfield.delegate = self
                methodDropDownInquiries()
                getReasonsForTrans()
            }
            
        }
        
        else{
            
            if selectedlist == "Rasst ID"
                
            {
                
                mobilenoTextfield.placeholder = "Enter Mobile No".addLocalizableString(languageCode: languageCode)
            }
            if  selectedlist == "IBAN"
            {
                
                mobilenoTextfield.placeholder = "Enter IBAN No".addLocalizableString(languageCode: languageCode)
            }
            
            amounttextfield.placeholder = "Enter amount (1.00- 50000)".addLocalizableString(languageCode:languageCode)
            //        Contactbtn.isHidden = false
            //        getAccounts()
            print("DataManager.instance.accountno", DataManager.instance.accountno)
            print("DataManager.instance.currentBalance", DataManager.instance.currentBalance)
            //        lblAccountNo.text =  (DataManager.instance.accountno ?? "")
            //        lblCurrentBalance.text = "Current Balance: \( DataManager.instance.currentBalance ?? "")"
            self.amounttextfield.delegate = self
            self.mobilenoTextfield.delegate = self
            methodDropDownInquiries()
            getReasonsForTrans()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func getContact(_ sender: UIButton) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var dropdownreason: DropDown!
    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var lblTransferAmount: UILabel!
    @IBOutlet weak var mobilenoTextfield: UITextField!
    @IBOutlet weak var lblmobileno: UILabel!
    @IBOutlet weak var dropdownType: DropDown!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblview: UIView!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var DropdownSourceAccount: DropDown!
    @IBOutlet weak var lblSourceAccount: UILabel!
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var lblAccountBalance: UILabel!
    
    @IBAction func canvel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func beneficiary(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BenefiaryListVC") as! BenefiaryListVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    @IBAction func Confirm(_ sender: UIButton) {
        
        if dropdownType.text?.count == 0
        {
            showToast(title: "Please Select Type")
        }
        
        if amounttextfield.text?.count == 0 {
            return
        }
        mobiletextfiledvalue =  mobilenoTextfield.text
        //        if mobilenoTextfield.text?.count ?? 0 <= 11 || amounttextfield.text?.count ?? 0 <= 24
        //        {
        //
        //            showToast(title: "Show Invalid Number")
        //        }
        if Float(amounttextfield.text!) ?? 0 < 1.00 || Float(amounttextfield.text!) ?? 0 > 200000.00 {
            self.showToast(title: "Invalid Amount")
            return
        }
        if dropdownreason.text?.count == 0
        {
            showToast(title: "Please Select Reason")
        }
        else
        
        {
            TitleFetchAlias()
        }
        
        //        api calling
        
        
        
        
        
        
    }
    
    func checlaliasvalue()
    {
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        if selectedlist == "Rasst ID"
        {
            if mobilenoTextfield.text?.count == 11
            {
                AliasType = "MOBILE"
                Contactbtn.isHidden = false
                lblmobileno.text = "Enter Mobile No".addLocalizableString(languageCode: languageCode)
                mobilenoTextfield.placeholder = "Enter Mobile No".addLocalizableString(languageCode: languageCode)
                print("mobile AliasType is", AliasType)
                mobilenoTextfield.keyboardType = UIKeyboardType.numberPad
            }
            if mobilenoTextfield.text?.count == 13
            {
                AliasType = "CNIC"
                lblmobileno.text = "Enter CNIC".addLocalizableString(languageCode: languageCode)
                mobilenoTextfield.placeholder = "Enter CNIC No".addLocalizableString(languageCode: languageCode)
                print("CNIC AliasType is", AliasType)
                mobilenoTextfield.keyboardType = UIKeyboardType.numberPad
            }
        }
        if selectedlist == "IBAN"
        {
            Contactbtn.isHidden = true
            lblmobileno.text = "Enter IBAN No".addLocalizableString(languageCode: languageCode)
            mobilenoTextfield.placeholder = "Enter IBAN No".addLocalizableString(languageCode: languageCode)
            AliasType = "IBAN"
            print("IBAN AliasType is", AliasType)
            mobilenoTextfield.keyboardType  = UIKeyboardType.asciiCapableNumberPad
        }
        
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        //        if textField == mobilenoTextfield{
        
        if dropdownType.text  == AliasSelectUserText
            
        {
            mobilenoTextfield.isUserInteractionEnabled = true
            mobilenoTextfield.keyboardType = UIKeyboardType.numberPad
            return newLength <= 11
        }
        if  dropdownType.text == AliasSelect
        {
            mobilenoTextfield.keyboardType = UIKeyboardType.namePhonePad
            mobilenoTextfield.isUserInteractionEnabled = true
            return newLength <= 24
        }
        if textField.text == amounttextfield.text{
            return newLength <= 5
        }
        
        
        return newLength <= 11
    }
    
    
    private func methodDropDownInquiries() {
        
        self.dropdownType.placeholder = "Select".addLocalizableString(languageCode: languageCode)
        self.dropdownType.selectedRowColor = UIColor.gray
        self.dropdownType.optionArray = ["Rasst ID","IBAN"]
        self.dropdownType.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.dropdownType.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropdownType.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropdownType.didSelect{ [self](b , index ,id) in
            self.dropdownType.selectedRowColor = UIColor.gray
            self.selectedlist = b
            if self.selectedlist == "Rasst ID"
            {
                Contactbtn.isHidden = false
                AliasSelectUserText = selectedlist!
                self.lblmobileno.text = "Enter Mobile No"
                
            }
            
            if self.selectedlist == "IBAN"
            {
                Contactbtn.isHidden = true
                AliasSelect = selectedlist!
                self.lblmobileno.text = "Enter IBAN No"
                
            }
        }
        self.checlaliasvalue()
        
        self.dropdownType.selectedRowColor = UIColor.gray
        self.dropdownType.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.dropdownType.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropdownType.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
    }
    
    private func methodDropDownAccounts(Accounts:[String]) {
        
        self.DropdownSourceAccount.placeholder = Accounts[0]
        self.DropdownSourceAccount.rowHeight = 30.0
        self.DropdownSourceAccount.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.sourceAccount = Accounts[0]
        self.DropdownSourceAccount.optionArray = Accounts
        //        self.DropdownSourceAccount.text = "\(Accounts)"
        self.DropdownSourceAccount.didSelect{(b , index ,id) in
            print("You Just select: \(b) at index: \(index)")
            self.DropdownSourceAccount.text = b
            self.sourceAccount = b
            
            DataManager.instance.selectedSourceAccount  = self.sourceAccount
            
        }
    }
    //    private func getAccounts() {
    //
    //        if !NetworkConnectivity.isConnectedToInternet(){
    //            self.showToast(title: "No Internet Available")
    //            return
    //        }
    //
    //        showActivityIndicator()
    //
    //
    //        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts"
    //        let header = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
    //
    //        print(header)
    //        print(compelteUrl)
    //
    //        NetworkManager.sharedInstance.enableCertificatePinning()
    ////        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Accounts>) in
    //
    //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<Accounts>) in
    ////
    //            self.hideActivityIndicator()
    //
    //            if response.response?.statusCode == 200 {
    //
    //                self.accountsObj = response.result.value
    //                if self.accountsObj?.response == 2 || self.accountsObj?.response == 1 {
    //
    //                    self.arrAccountList = self.accountsObj?.stringAccounts
    //                    //                    self.currentID = self.issueListObj?.issuesList?[0].id
    //                    self.methodDropDownAccounts(Accounts: (self.arrAccountList)!)
    //
    //                }
    //                else {
    //                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
    //                }
    //            }
    //            else {
    //
    //                print(response.result.value)
    //                print("api response is ",response.response?.statusCode)
    //
    //            }
    //
    //
    //}
    //    }
    private func methodDropDownReasons(Reasons:[String]) {
        self.dropdownreason.placeholder = "Select Reasons"
        self.dropdownreason.placeholder = Reasons[0]
        self.dropdownreason.rowHeight = 30.0
        self.dropdownreason.optionArray = Reasons
        self.dropdownreason.didSelect{(b , index ,id) in
            self.selectedReason = b
            self.FetchPurposeID()
            self.dropdownreason.selectedRowColor = UIColor.gray
            self.dropdownreason.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.dropdownreason.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.dropdownreason.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            
        }
        
    }
    var userCnic : String?
    func getcnic()
    {
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
    }
    var reasonsList = [List]()
    var arrReasonsList : [String]?
    
    
    
    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/TransactionReasons"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<RaastReason>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<RaastReason>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.reasonObj = Mapper<RaastReason>().map(JSONObject: json)
                    if self.reasonObj?.response == 2 || self.reasonObj?.response == 1 {
                        if let reasonCodes = self.reasonObj?.singleReason{
                            self.reasonsList = reasonCodes
                        }
                        
                        self.arrReasonsList = self.reasonObj?.stringReasons
                        
                        
                        self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                        //                    self.getTransactionConsent()
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
    
    var PurposeID : String?
    func FetchPurposeID()
    {
        
        if let  productlist = self.reasonObj?.singleReason
        {
            for data in productlist
            {
                //                if selectedCustomerType == data.customerTypeDescr
                //                {
                //                    self.CustomerId = data.customerTypeId
                //
                //                }
                self.PurposeID =  data.code
                PurpseReasonId =  self.PurposeID
                
                print("PurposeID is ", PurposeID)
            }
            
            
        }
    }
    
    private func TitleFetchAlias(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/TitleFetch"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        //        let params = ["lat" : DataManager.instance.Latitude! , "lng": DataManager.instance.Longitude! , "imei": DataManager.instance.imei! ,"cnic": , "account_number": DataManager.instance.accountno ?? "" ,"alias_type": (selectedlist! ?? ""),"alias_value": (mobilenoTextfield.text! ?? "")] as [String : Any]
        
        let params = ["lat" : DataManager.instance.Latitude!, "lng": DataManager.instance.Longitude! , "imei": DataManager.instance.imei! ,"cnic": userCnic! ?? "", "account_number": DataManager.instance.accountno ?? "" ,"alias_type": (AliasType ?? ""),"alias_value": (mobilenoTextfield.text! ?? "")] as [String : Any]
        //"7140101815733"
        print(compelteUrl)
        print(params)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<TransationByAliasModel>) in
            
            
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<TransationByAliasModel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.TransationByAliasModelobj = Mapper<TransationByAliasModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.TransationByAliasModelobj?.response == 2{
                        
                        
                        if let message = self.TransationByAliasModelobj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                //                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaastSubvIew2Vc") as!  RaastSubvIew2Vc
                                //
                                //                             self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                    }
                    
                    if   self.TransationByAliasModelobj?.response == 1 {
                        //                    sending value
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AliasTransactionConfirmationVC") as! AliasTransactionConfirmationVC
                        //                    my account no
                        DataManager.instance.sourceAccount =  self.TransationByAliasModelobj?.transaction?.fromAliasValue
                        
                        DataManager.instance.transferaliasAmount = self.amounttextfield.text
                        DataManager.instance.reason = self.selectedReason
                        //                    myiban
                        DataManager.instance.sourceiban = self.TransationByAliasModelobj?.transaction?.fromAccountIban
                        //                    ny name
                        DataManager.instance.sourceAccTitle = self.TransationByAliasModelobj?.transaction?.fromAccounttitle
                        
                        DataManager.instance.beneficaryAccount = self.TransationByAliasModelobj?.transaction?.accountTitle
                        //                    DataManager.instance.benealias = self.TransationByAliasModelobj?.transaction?.fromAliasValue
                        //                    reviver mobile no
                        DataManager.instance.benealias = self.mobilenoTextfield.text! ?? ""
                        
                        DataManager.instance.bebeiban = self.TransationByAliasModelobj?.transaction?.iban! ?? ""
                        
                        DataManager.instance.uniqkey = self.TransationByAliasModelobj?.transaction?.unique_unique_key
                        DataManager.instance.mid = self.TransationByAliasModelobj?.transaction?.memberId
                        DataManager.instance.BeneficiaryBankname = self.TransationByAliasModelobj?.transaction?.toBankName
                        DataManager.instance.transferAmount = self.amounttextfield.text
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        if let message = self.TransationByAliasModelobj?.message{
                            //                    self.showAlert(title: "", message: message, completion: {
                            //                        self.navigationController?.popToRootViewController(animated: true)
                            //                    })
                        }                }
                }
                else {
                    
                    if let message = self.TransationByAliasModelobj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        }
                        else{
                            self.showAlert(title: "", message: message, completion: {
                                //                    self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
                    }
                    
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
            
        }
    }
    func replaceSpaceWithEmptyString(aStr:String) -> String {
        let replacedString = aStr.replacingOccurrences(of: " ", with: "")
        
        return replacedString
    }
}
extension TransferByAliasVC: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
        //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        //        self.nameTextField.text = name
        
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }
        
        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
            
        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
            
            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                    alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
                alert -> Void in
                
            })
            alertController.addAction(cancelAction)
            
            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setNumberFromContact(contactNumber: String) {
        
        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER
        
        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        
        
        
        let phoneUtil = NBPhoneNumberUtil()
        
        do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)
            
            print("Formatted String : \(formattedString)")
            self.mobilenoTextfield.text = replaceSpaceWithEmptyString(aStr: formattedString)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
