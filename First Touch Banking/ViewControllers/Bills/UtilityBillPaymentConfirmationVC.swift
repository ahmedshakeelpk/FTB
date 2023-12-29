//
//  UtilityBillPaymentConfirmationVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 11/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SkyFloatingLabelTextField
import ObjectMapper


class UtilityBillPaymentConfirmationVC: BaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var lblCompanyNameValue: UILabel!
    @IBOutlet weak var lblCustomerNameValue: UILabel!
    @IBOutlet weak var lblBillStatusValue: UILabel!
    @IBOutlet weak var lblBillStatusLabel: UILabel!
    @IBOutlet weak var lblDueDateValue: UILabel!
    @IBOutlet weak var lblAmountWithinValue: UILabel!
    @IBOutlet weak var lblAmountWithinLabel: UILabel!
    @IBOutlet weak var lblAmountAfterValue: UILabel!
    @IBOutlet weak var lblAmountAfterLabel: UILabel!
    @IBOutlet weak var lblPayableAmountValue: UILabel!
    
    
    @IBOutlet weak var lblsubtitle: UILabel!
    @IBOutlet weak var lblMian: UILabel!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnpaynow: UIButton!
    @IBOutlet weak var lblAddbene: UILabel!
    @IBOutlet weak var lblCustomerNameTitle : UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    
    var billPaymentTransferObj : BillPaymentTransfer?
    
    var companyName:String?
    var companyCode:String?
    var customerName:String?
    var billStatus:String?
    var dueDate:String?
    var amountWithin:String?
    var amountAfter:String?
    var payableAmount:String?
    var consumerNumber:String?
    var utilityCompanyID : String?
    
    @IBOutlet weak var payNowButton: UIButton!
    static let networkManager = NetworkManager()
    @IBOutlet  var nickNameTextField: SkyFloatingLabelTextField!
    @IBOutlet  var mobileNumberTextField: UITextField!
    @IBOutlet  var emailTextField: UITextField!
    @IBOutlet  var payableAmountTextField: SkyFloatingLabelTextField!
    @IBOutlet var viewBottomButtonsUpperConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomButtonsDownConstraint: NSLayoutConstraint!
    var addBeneficiary:Bool?
    @IBOutlet weak var viewAddBeneficiary: UIView!
    @IBOutlet var btn_AddBene: UIButton!
    func Converlanguage()
    {
        
        lblMian.text = "Bill Payment Confirmation".addLocalizableString(languageCode: languageCode)
        lblsubtitle.text = "Payment Confirmation".addLocalizableString(languageCode: languageCode)
        lblAddbene.text = "Add Beneficiary".addLocalizableString(languageCode: languageCode)
        
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnpaynow.setTitle("PAYNOW".addLocalizableString(languageCode: languageCode), for: .normal)
        nickNameTextField.placeholder = "NickName".addLocalizableString(languageCode: languageCode)
        mobileNumberTextField.placeholder = "Moible Number".addLocalizableString(languageCode: languageCode)
        emailTextField.placeholder = "Email".addLocalizableString(languageCode: languageCode)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.updateUI()
        Converlanguage()
        addBeneficiary = true
        
        btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true
        mobileNumberTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailFieldEditingChanged(_:)), for: .editingDidEnd)
        
        //        if let imdComp = self.utilityCompanyID {
        //            if imdComp == "CC01BILL"{
        //                self.payableAmountTextField.isUserInteractionEnabled = true
        //                self.lblAmountWithinLabel.isHidden = true
        //                self.lblAmountWithinValue.isHidden = true
        //                self.lblAmountAfterLabel.isHidden = true
        //                self.lblAmountAfterValue.isHidden = true
        //                self.lblBillStatusLabel.isHidden = true
        //                self.lblBillStatusValue.isHidden = true
        //
        //            }
        //        }
        
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
            return
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        
        //        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        if textField == mobileNumberTextField
        {
            return  newLength <= 11
        }
        
        return true
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
        
        if let company = self.companyName{
            self.lblCompanyNameValue.text = company
            
        }
        
        if let customer = self.customerName {
            
            if customer == "NOT AVAILABLE"{
                if let consumer = self.consumerNumber{
                    self.lblCustomerNameValue.text = consumer
                    self.lblCustomerNameTitle.text = "Consumer Number"
                    
                }
            }
            else {
                self.lblCustomerNameValue.text = customer
                self.nickNameTextField.text = customer
            }
        }
        
        
        if let status = self.billStatus{
            if status == "U"{
                self.lblBillStatusValue.text = "Unpaid"
            }
            if status == "P"{
                self.lblBillStatusValue.text = "Paid"
            }
            if status == "T"{
                self.lblBillStatusValue.text = "Partial Payment"
            }
            if status == "B"{
                self.lblBillStatusValue.text = "Blocked"
            }
        }
        if let date = self.dueDate{
            self.lblDueDateValue.text = date
        }
        if let amountwithin = self.amountWithin{
            self.lblAmountWithinValue.text = "PKR \(amountwithin).00"
        }
        else{
            self.lblAmountWithinValue.text = "Not Available"
        }
        if let amountafter = self.amountAfter{
            self.lblAmountAfterValue.text = "PKR \(amountafter).00"
        }
        else{
            self.lblAmountAfterValue.text = "Not Available"
        }
        if let amountpay = self.payableAmount{
            self.lblPayableAmountValue.text = "PKR \(amountpay).00"
            self.payableAmountTextField.text = amountpay
        }
        else{
            self.lblPayableAmountValue.text = "Not Available"
        }
    }
    
    private func navigateToDetailsVC(){
        
        let billPaymentDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "BillPaymentDetailsVC") as! BillPaymentDetailsVC
        
        billPaymentDetailsVC.companyName = self.companyName
        billPaymentDetailsVC.customerName = self.customerName
        billPaymentDetailsVC.billStatus = self.billStatus
        billPaymentDetailsVC.dueDate = self.dueDate
        billPaymentDetailsVC.paidAmount = self.payableAmountTextField.text!
        billPaymentDetailsVC.transRefNumber = self.billPaymentTransferObj?.stan
        billPaymentDetailsVC.transTime = self.billPaymentTransferObj?.tran_time
        
        self.navigationController!.pushViewController(billPaymentDetailsVC, animated: true)
    }
    // MARK: - Action Method
    func checkEmailValid()
    {
        if isValidEmail(testStr: emailTextField.text!) == true {
            self.payBillPayment()
        }
        else
        {
            return()
        }
    }
    @IBAction func paynowPressed(_ sender: Any) {
        if self.payableAmount == nil {
            self.showDefaultAlert(title: "Error", message: "Payable amount not available")
            return
        }
        //        add logic here...
        if emailTextField.text?.count == 0
        {
            self.payBillPayment()
        }
        else
        {
            checkEmailValid()
        }
        
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
    
    // MARK: - API Call
    
    private func payBillPayment() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/BillPayment"
        
        if (mobileNumberTextField.text?.isEmpty)!{
            self.mobileNumberTextField.text = ""
        }
        if (nickNameTextField.text?.isEmpty)!{
            self.nickNameTextField.text = ""
        }
        if (emailTextField.text?.isEmpty)!{
            self.emailTextField.text = ""
        }
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"UtilityCompanyId":self.companyCode!,"UtilityConsumerNumber":self.consumerNumber!, "AmountPaid":self.payableAmountTextField.text!,"beneficiary_name":nickNameTextField.text!,"beneficiary_mobile":mobileNumberTextField.text!,"beneficiary_email":emailTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<BillPaymentTransfer>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<BillPaymentTransfer>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.billPaymentTransferObj = Mapper<BillPaymentTransfer>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.billPaymentTransferObj?.response == 0
                    {
                        if let message = self.billPaymentTransferObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                    if self.billPaymentTransferObj?.response == 2 || self.billPaymentTransferObj?.response == 1 {
                        
                        self.navigateToDetailsVC()
                        
                    }
                    else {
                        if let message = self.billPaymentTransferObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.billPaymentTransferObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                }
            }
        }
    }
}
