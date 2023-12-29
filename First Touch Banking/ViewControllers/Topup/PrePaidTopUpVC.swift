//
//  PrePaidTopUpVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SkyFloatingLabelTextField
import ObjectMapper

class PrePaidTopUpVC: BaseVC , UITextFieldDelegate {
    
    @IBOutlet var dropDownAccounts: UIDropDown!
    @IBOutlet var lblMainTitle : UILabel!
    var mainTitle : String?
    @IBOutlet weak var receiverNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    var companyID : String?
    var arrCompaniesList : [String]?
    var billCompanyListObj : BillPaymentCompaniesListDropDown?
    var comapniesList = [SingleCompanyList]()
    var sourceCompany: String?
    var companyCode: String?
    var billPaymentInquiryObj: BillPaymentInquiry?
    static let networkManager = NetworkManager()
    @IBOutlet weak var lblCurrentBalance: UILabel!
    var isFromHome:Bool = false
    var isFromQuickPay:Bool = false
    var consumerNumber : String?
    
    
    
    
    @IBOutlet weak var lblMain: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Top Up".addLocalizableString(languageCode: languageCode)
        if let balanceValue = DataManager.instance.currentBalance {
            self.lblCurrentBalance.text = "Balance : PKR \(balanceValue)"
        }
        if let titleText = mainTitle{
            if titleText == "Mobile Top-up"{
                self.lblMainTitle.text = "Prepaid"
            }
        }
        
        if isFromQuickPay{
            self.receiverNumberTextField.isUserInteractionEnabled = false
            self.updateUI()
        }
        else {
            self.getCompanies()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Utility Methods
    
    private func updateUI(){
        
        if let beneCompany = self.mainTitle{
            methodDropDownAccounts(Companies: [beneCompany])
        }
        if let receiver = self.consumerNumber{
            self.receiverNumberTextField.text = receiver
        }
        if let company = self.mainTitle{
            self.sourceCompany = company
        }
    }
    
    private func navigateToConfirmationVC(code: String){
        
        let prePaidConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "PrePaidTopUpConfirmationVC") as! PrePaidTopUpConfirmationVC
        
        prePaidConfirmVC.companyName = self.sourceCompany
        
        if let mobileNumber = self.receiverNumberTextField.text{
            prePaidConfirmVC.mobileNumber = mobileNumber
        }
        if let amount = self.amountTextField.text{
            prePaidConfirmVC.transferAmount = amount
        }
        prePaidConfirmVC.companyCode = self.companyCode
        
        
        self.navigationController!.pushViewController(prePaidConfirmVC, animated: true)
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == receiverNumberTextField{
            return newLength <= 11
        }
        else {
            return newLength <= 16
        }
    }
    
    //MARK: - DropDown
    
    private func methodDropDownAccounts(Companies:[String]) {
        
        if isFromQuickPay {
            self.dropDownAccounts.placeholder = Companies[0]
        }
        else {
            self.dropDownAccounts.placeholder = "Select Company"
        }
        //        self.dropDownAccounts.placeholder = "Select Company"
        self.dropDownAccounts.options = Companies
        self.dropDownAccounts.tableHeight = 200.0
        self.dropDownAccounts.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.sourceCompany = option
            
        })
    }
    
    // MARK: - Action Method
    
    @IBAction func paynowPressed(_ sender: Any) {
        
        let title = self.sourceCompany
        for aCompany in self.comapniesList {
            if aCompany.name == title {
                //ibftFundConfirmVC.singleBank = aBank
                print(aCompany.name!)
                print(aCompany.code!)
                self.companyCode = aCompany.code!
            }
        }
        
        if self.companyCode == nil{
            self.showDefaultAlert(title: "Alert", message: "Kindly select company")
            return
        }
        if receiverNumberTextField.text == nil || self.receiverNumberTextField.text == ""{
            self.showDefaultAlert(title: "Alert", message: "Kindly enter mobile number")
            return
        }
        if self.amountTextField.text == nil || self.amountTextField.text == ""{
            self.showDefaultAlert(title: "Alert", message: "Kindly enter amount")
            return
        }
        if Double(amountTextField.text!)! < 100 || Double(amountTextField.text!)! > 1500 || self.amountTextField.text == nil{
            self.showDefaultAlert(title: "Alert", message: "Kindly enter amount between 100-1500")
            return
        }
        //        if let balanceValue = DataManager.instance.currentBalance {
        //            if (amountTextField.text)! > String(Float(balanceValue)!) {
        //                self.showDefaultAlert(title: "Alert", message: "Amount Exceed")
        //                return
        //            }
        //        }
        if isFromQuickPay {
            self.getBillInquiry(code: self.companyCode!)
        }
        self.getBillInquiry(code: self.companyCode!)
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - API CALL
    
    private func getCompanies() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/BillPayment/Companies/"+String(self.companyID!)
        let header:HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<BillPaymentCompaniesListDropDown>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BillPaymentCompaniesListDropDown>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.billCompanyListObj = Mapper<BillPaymentCompaniesListDropDown>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.billCompanyListObj?.response == 2 || self.billCompanyListObj?.response == 1 {
                        
                        if let companies = self.billCompanyListObj?.companies {
                            self.comapniesList = companies
                        }
                        self.arrCompaniesList = self.billCompanyListObj?.stringCompaniesList
                        self.methodDropDownAccounts(Companies: (self.arrCompaniesList)!)
                        
                    }
                    else {
                        if let message = self.billCompanyListObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.billCompanyListObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                }
            }
        }
    }
    
    private func getBillInquiry(code:String) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/BillInquiry"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"UtilityCompanyId":code,"UtilityConsumerNumber":self.receiverNumberTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<BillPaymentInquiry>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<BillPaymentInquiry>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.billPaymentInquiryObj = Mapper<BillPaymentInquiry>().map(JSONObject: json)
                    
                    //                self.billPaymentInquiryObj = response.result.value
                    if self.billPaymentInquiryObj?.response == 2 || self.billPaymentInquiryObj?.response == 1 {
                        
                        self.navigateToConfirmationVC(code: code)
                        
                    }
                    else {
                        if let message = self.billPaymentInquiryObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.billPaymentInquiryObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
