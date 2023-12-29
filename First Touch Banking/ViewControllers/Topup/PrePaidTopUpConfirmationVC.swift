//
//  PrePaidTopUpConfirmationVC.swift
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


class PrePaidTopUpConfirmationVC: BaseVC, UITextFieldDelegate {
    @IBOutlet weak var lblCompanyNameValue: UILabel!
    @IBOutlet weak var lblMobileNumberValue: UILabel!
    @IBOutlet weak var lblTransferAmountValue: UILabel!
    var companyName:String?
    var mobileNumber:String?
    var transferAmount:String?
    var companyCode:String?
    var prepaidObj: PrePaidTransfer?
    static let networkManager = NetworkManager()
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnpaynow: UIButton!
    @IBOutlet weak var lblAddbene: UILabel!
    @IBOutlet weak var lblsubTitle: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet  var nickNameTextField: SkyFloatingLabelTextField!
    @IBOutlet  var mobileNumberTextField: UITextField!
    @IBOutlet  var emailTextField: UITextField!
    @IBOutlet var viewBottomButtonsUpperConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomButtonsDownConstraint: NSLayoutConstraint!
    var addBeneficiary:Bool?
    @IBOutlet weak var viewAddBeneficiary: UIView!
    @IBOutlet var btn_AddBene: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func Changelanguage()
    {
        
        lblmain.text = "Top Up".addLocalizableString(languageCode: languageCode)
        lblsubTitle.text = "Pre Paid Confirmation".addLocalizableString(languageCode: languageCode)
        lblAddbene.text = "Add Beneficiary".addLocalizableString(languageCode: languageCode)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnpaynow.setTitle("PAYNOW".addLocalizableString(languageCode: languageCode), for: .normal)
        nickNameTextField.placeholder = "NickName".addLocalizableString(languageCode: languageCode)
        mobileNumberTextField.placeholder = "Mobile Number".addLocalizableString(languageCode: languageCode)
        emailTextField.placeholder = "Email".addLocalizableString(languageCode: languageCode)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguage()
        mobileNumberTextField.delegate = self
        emailTextField.delegate = self
        self.updateUI()
        addBeneficiary = true
        btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true
        self.emailTextField.addTarget(self, action: #selector(emailFieldEditingChanged(_:)), for: .editingDidEnd)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        if textField == mobileNumberTextField
        {
            return  newLength <= 11
        }
        
        return true
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        
        //        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        if let company = self.companyName{
            self.lblCompanyNameValue.text = company
            self.nickNameTextField.text = company
        }
        if let mobileNo = self.mobileNumber{
            self.lblMobileNumberValue.text = mobileNo
        }
        if let tAmount = self.transferAmount{
            self.lblTransferAmountValue.text = tAmount
        }
        
    }
    
    private func navigateToDetailsVC(){
        
        let prepaidDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "PrepaidTopUpDetailVC") as! PrepaidTopUpDetailVC
        
        prepaidDetailsVC.companyName = self.companyName
        prepaidDetailsVC.MobileNumber = self.mobileNumber
        prepaidDetailsVC.TransferAmount = self.transferAmount
        prepaidDetailsVC.transTime = self.prepaidObj?.tran_time
        prepaidDetailsVC.transRefNumber = self.prepaidObj?.stan
        
        self.navigationController!.pushViewController(prepaidDetailsVC, animated: true)
    }
    
    // MARK: - Action Method
    
    func checkEmailValid()
    {
        if isValidEmail(testStr: emailTextField.text!) == true {
            payPrePaidBillPayment()
        }
        else
        {
            return()
        }
    }
    @IBAction func paynowPressed(_ sender: Any) {
        
        if emailTextField.text?.count == 0
        {
            payPrePaidBillPayment()
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
    
    private func payPrePaidBillPayment() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/BillPayment"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"UtilityCompanyId":self.companyCode!,"UtilityConsumerNumber":self.mobileNumber!, "AmountPaid":self.transferAmount!,"beneficiary_name":nickNameTextField.text!,"beneficiary_mobile":mobileNumberTextField.text!,"beneficiary_email":emailTextField.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<PrePaidTransfer>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<PrePaidTransfer>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.prepaidObj = Mapper<PrePaidTransfer>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.prepaidObj?.response == 2 || self.prepaidObj?.response == 1 {
                        self.navigateToDetailsVC()
                    }
                    else {
                        if let message = self.prepaidObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.prepaidObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}

