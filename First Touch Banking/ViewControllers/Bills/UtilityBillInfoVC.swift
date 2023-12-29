//
//  UtilityBillInfoVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 10/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SkyFloatingLabelTextField
import ObjectMapper

class UtilityBillInfoVC: BaseVC {
    
    @IBOutlet var dropDownAccounts: UIDropDown!
    var billCompanyListObj : BillPaymentCompaniesListDropDown?
    @IBOutlet var lblMainTitle : UILabel!
    var mainTitle : String?
    var arrCompaniesList : [String]?
    var sourceCompany: String?
    var sourceCompanyCode: String?
    var consumerNumber : String?
    var companyID : String?
    var comapniesList = [SingleCompanyList]()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var consumerNumberTextField: SkyFloatingLabelTextField!
    var billPaymentInquiryObj: BillPaymentInquiry?
    var companyCode: String?
    var isFromQuickPay:Bool = false
    var isFromHome:Bool = false
    
    @IBOutlet weak var lblmain: UILabel!
    
    @IBOutlet weak var lblConsumer: UILabel!
    @IBOutlet weak var lblselctCom: UILabel!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnsubmit: UIButton!
    static let networkManager = NetworkManager()
    func Convertlanguage()
    {
        lblmain.text = "Bill Payments".addLocalizableString(languageCode: languageCode)
        lblMainTitle.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        btnsubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btncancel.setTitle("Cancel".addLocalizableString(languageCode: languageCode), for: .normal)
        lblselctCom.text = "Select Company".addLocalizableString(languageCode: languageCode)
        lblConsumer.text = "Consumer Number".addLocalizableString(languageCode: languageCode)
        consumerNumberTextField.placeholder = "Enter Consumer Number".addLocalizableString(languageCode: languageCode)
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Convertlanguage()
        
        
        if self.isFromQuickPay == true{
            self.consumerNumberTextField.isUserInteractionEnabled = false
            self.updateUI()
        }
        if self.isFromHome == true{
            self.getCompanies()
        }
        
        if let titleText = mainTitle{
            self.lblMainTitle.text = titleText
        }
        
        // Do any additional setup after loading the view.
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
    
    private func updateUI(){
        
        if let companyId = self.mainTitle{
            methodDropDownAccounts(Companies: [companyId])
        }
        if let cosumerNo = consumerNumber {
            self.consumerNumberTextField.text = cosumerNo
        }
        
    }
    
    private func navigateToDetailsVC(code:String){
        
        if let imdComp = self.billPaymentInquiryObj?.utility_company_id {
            
            // One Bill Redirection
            if imdComp == "CC01BILL" || imdComp == "IN01BILL" || imdComp == "TP01BILL" || imdComp == "CAREEM01"{
                
                let utilityBillPayOneBillConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillConfirmationOneBillVC") as! UtilityBillConfirmationOneBillVC
                
                
                if isFromQuickPay {
                    utilityBillPayOneBillConfirmVC.companyName = self.mainTitle
                }
                else {
                    utilityBillPayOneBillConfirmVC.companyName = self.sourceCompany
                }
                utilityBillPayOneBillConfirmVC.customerName = self.billPaymentInquiryObj?.customer_name
                utilityBillPayOneBillConfirmVC.billStatus = self.billPaymentInquiryObj?.bill_status
                utilityBillPayOneBillConfirmVC.dueDate = self.billPaymentInquiryObj?.due_date
                utilityBillPayOneBillConfirmVC.payableAmount = self.billPaymentInquiryObj?.amount
                utilityBillPayOneBillConfirmVC.companyCode = code
                utilityBillPayOneBillConfirmVC.consumerNumber = self.consumerNumberTextField.text
                utilityBillPayOneBillConfirmVC.utilityCompanyID = self.billPaymentInquiryObj?.utility_company_id
                
                self.navigationController!.pushViewController(utilityBillPayOneBillConfirmVC, animated: true)
            }
            else{
                
                let utilityBillPayConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentConfirmationVC") as! UtilityBillPaymentConfirmationVC
                
                if isFromQuickPay {
                    utilityBillPayConfirmVC.companyName = self.mainTitle
                }
                else {
                    utilityBillPayConfirmVC.companyName = self.sourceCompany
                }
                utilityBillPayConfirmVC.customerName = self.billPaymentInquiryObj?.customer_name
                utilityBillPayConfirmVC.billStatus = self.billPaymentInquiryObj?.bill_status
                utilityBillPayConfirmVC.dueDate = self.billPaymentInquiryObj?.due_date
                utilityBillPayConfirmVC.amountWithin = self.billPaymentInquiryObj?.amount_with_in_duedate
                utilityBillPayConfirmVC.amountAfter = self.billPaymentInquiryObj?.amount_after_duedate
                utilityBillPayConfirmVC.payableAmount = self.billPaymentInquiryObj?.amount
                utilityBillPayConfirmVC.companyCode = code
                utilityBillPayConfirmVC.consumerNumber = self.consumerNumberTextField.text
                utilityBillPayConfirmVC.utilityCompanyID = self.billPaymentInquiryObj?.utility_company_id
                
                self.navigationController!.pushViewController(utilityBillPayConfirmVC, animated: true)
            }
        }
    }
    
    
    //MARK: - DropDown
    
    private func methodDropDownAccounts(Companies:[String]) {
        
        print("\(companyID)")
        
        if let comanyId = self.companyID{
            if comanyId == "GOV"{
                dropDownAccounts.tableHeight = 200.0
            }
            if comanyId == "BBP"{
                dropDownAccounts.tableHeight = 200.0
            }
        }
        
        if isFromQuickPay {
            self.dropDownAccounts.placeholder = Companies[0]
        }
        else {
            self.dropDownAccounts.placeholder = "Select Company"
        }
        self.dropDownAccounts.options = Companies
        self.dropDownAccounts.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.sourceCompany = option
            
        })
    }
    
    // MARK: - Action Method
    
    @IBAction func paynowPressed(_ sender: Any) {
        
        if isFromQuickPay {
            self.getBillInquiry(code: self.companyID!)
        }
        else {
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
                self.showToast(title: "Please select company")
                return
            }
            if self.consumerNumberTextField.text?.count == 0 {
                self.showToast(title: "Please enter Consumer Number")
                return
            }
            self.getBillInquiry(code: self.companyCode!)
        }
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
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<BillPaymentCompaniesListDropDown>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BillPaymentCompaniesListDropDown>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.billCompanyListObj = Mapper<BillPaymentCompaniesListDropDown>().map(JSONObject: json)
                    
//                    self.billCompanyListObj = response.result.value
                    if self.billCompanyListObj?.response == 2 || self.billCompanyListObj?.response == 1 {
                        
                        if let companies = self.billCompanyListObj?.companies {
                            self.comapniesList = companies
                        }
                        self.arrCompaniesList = self.billCompanyListObj?.stringCompaniesList
                        self.methodDropDownAccounts(Companies: (self.arrCompaniesList)!)
                        
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
    
    private func getBillInquiry(code:String) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/BillInquiry"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"UtilityCompanyId":code,"UtilityConsumerNumber":self.consumerNumberTextField.text!] as [String : Any]
        
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
                self.billPaymentInquiryObj = Mapper<BillPaymentInquiry>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.billPaymentInquiryObj?.response == 2 || self.billPaymentInquiryObj?.response == 1 {
                        
                        self.navigateToDetailsVC(code: code)
                        
                    }
                    else {
                        if let message = self.billPaymentInquiryObj?.message{
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                }
                else {
                    if let message = self.billPaymentInquiryObj?.message{
                        self.showDefaultAlert(title: "Alert", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
