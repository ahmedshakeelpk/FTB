//
//  StopPaymentVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
//import AlamofireObjectMapper
import ObjectMapper

import iOSDropDown
class StopPaymentVC: BaseVC , MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    var CheckLeafObj : LeafInq?
    var genericResponse:GenericResponse?
    var selectLeaf : String?
    var descrptionlist = [String]()
    var SelectedFromLeaf : String?
    var selectedlistt : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        lblmessagebox.delegate = self
        
        self.lblmessagebox.layer.borderColor = UIColor.lightGray.cgColor
        self.lblmessagebox.layer.borderWidth = 1
        ChequeLeafInquiry()
        self.enterfromleaftextfield.didSelect{(b , index ,id) in
            
            self.enterfromleaftextfield.isSelected = true
            self.enterfromleaftextfield.selectedRowColor = UIColor.gray
            self.enterfromleaftextfield.isSearchEnable = true
            self.SelectedFromLeaf = self.enterfromleaftextfield.text
            self.SelectedFromLeaf = b
            print("SelectedFromLeaf", self.SelectedFromLeaf)
        }
        self.EnterToLeafTextField.didSelect{(b , index ,id) in
            self.EnterToLeafTextField.isSelected = true
            self.EnterToLeafTextField.selectedRowColor = UIColor.gray
            self.EnterToLeafTextField.isSearchEnable = true
            self.selectedlistt = self.EnterToLeafTextField.text
            self.selectedlistt = b
            print("selectedlistt", self.selectedlistt)
        }
        
        // Do any additional setup after loading the view.
    }
    func ChangeLanguage()
    {
        lblMain.text = "Stop Payment".addLocalizableString(languageCode: languageCode)
        lblenterfromLeaf.text = "Enter From Leaf".addLocalizableString(languageCode: languageCode)
        lblenterToLeaf.text = "Enter To Leaf".addLocalizableString(languageCode: languageCode)
        lblEnterReason.text = "Enter The Reason".addLocalizableString(languageCode: languageCode)
        lblmessagebox.text = "Enter The Reason".addLocalizableString(languageCode: languageCode)
        btnstop.setTitle("STOP PAYMENT".addLocalizableString(languageCode: languageCode), for: .normal)
    
        enterfromleaftextfield.placeholder = "Please Enter From Leaf".addLocalizableString(languageCode: languageCode)
        EnterToLeafTextField.placeholder = "Please  Enter To Leaf".addLocalizableString(languageCode: languageCode)
    }
    
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblenterfromLeaf: UILabel!
    @IBOutlet weak var btnstop: FTBButton!
    @IBOutlet weak var lblmessagebox: UITextView!
    @IBOutlet weak var lblEnterReason: UILabel!
    @IBOutlet weak var EnterToLeafTextField: DropDown!
    @IBOutlet weak var lblenterToLeaf: UILabel!
    @IBOutlet weak var enterfromleaftextfield: DropDown!
    
    @IBAction func stopPayment(_ sender: UIButton) {
        if (self.enterfromleaftextfield.text?.isEmpty)!{
            self.showDefaultAlert(title: "", message: "Please Select From Leaf")
            return
             }
        if(self.EnterToLeafTextField.text?.isEmpty)!{
            self.showDefaultAlert(title: "", message: "Please Select To Leaf")
            return
        }
        if (self.lblmessagebox.text?.isEmpty ?? true)!{
            self.showDefaultAlert(title: "", message: "Please Enter Message")
            return
        }
        self.StopChequePaymentOTP()
       
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func ChequeLeafInquiry(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/ChequeLeafInquiry"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)

        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<LeafInq>) in
            
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<LeafInq>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.CheckLeafObj = Mapper<LeafInq>().map(JSONObject: json)
                    
                    if self.CheckLeafObj?.response == 2 || self.CheckLeafObj?.response == 1 {
                        
                        if let purposedescrlist = self.CheckLeafObj?.LIdata{
                            for data in purposedescrlist
                            {
                                self.descrptionlist.append("\(data.chequebook_no! ?? 0)" ?? "" )
                                if self.selectLeaf == data.leaf_no?[0].value
                                {
                                    //                                self.loanid = data.nlPurposeId
                                    //                                print(self.loanid)
                                    //                                DataManager.instance.Nanoloantype = self.loanid
                                    //                                print(DataManager.instance.Nanoloantype)
                                }
                                //                            self.loanid = data.nlPurposeId!
                            }
                            self.enterfromleaftextfield.optionArray = (self.descrptionlist)
                            self.EnterToLeafTextField.optionArray = (self.descrptionlist)
                            
                        }
                        
                        //                    if let message = self.CheckLeafObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
                    }
                    else {
                        if let message = self.CheckLeafObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.CheckLeafObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue :
            self.showToast(title: "Message canceled")
            print("message canceled")
        case MessageComposeResult.failed.rawValue :
            self.showToast(title: "Message failed")
            print("message failed")
        case MessageComposeResult.sent.rawValue :
            self.showToast(title: "Message sent")
            print("message sent")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.rangeOfCharacter(from: .letters) != nil || string == " " {
            return true
        }
        else if !(string == "" && range.length > 0) {
        return false
        
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.rangeOfCharacter(from: .letters) != nil || text == " " {
                   return true
               }
               else if !(text == "" && range.length > 0) {
               return false
               }
        if text == "\n"
        {
            lblmessagebox.resignFirstResponder()
        }
  
        
               return true
        
    }
func textViewDidBeginEditing(_ textView: UITextView) {
 
    lblmessagebox.text = ""
        
   }
    private func StopChequePaymentOTP() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/StopChequePayment/OTP"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                    if self.genericResponse?.response == 1 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                        
                        IsFromChequeBookRequest = "false"
                        isFromStopPyemnt = "true"
                        vc.from_leaf = self.SelectedFromLeaf!
                        vc.to_laf =  self.selectedlistt!
                        vc.stop_payment_reason =  self.lblmessagebox.text!
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    else {
                        if let messageErrorTrans = self.genericResponse?.message{
                            self.showDefaultAlert(title: "", message: messageErrorTrans)
                        }
                    }
                }
                else {
//                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                    if let messageErrorTrans = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: messageErrorTrans)
                    }
                }
            }
        }
    }
}
