//
//  ContactUsVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 28/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MessageUI
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper


class ContactUsVC: BaseVC , MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var dropDownInquiries: UIDropDown!
    @IBOutlet  var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var messageTextView: UITextView!
    var selectedCategory:String?
    var genericObj:GenericResponse?
    
    @IBOutlet weak var btnsend: UIButton!
    
    @IBOutlet weak var lblmaintitle: UILabel!
    static let networkManager = NetworkManager()
    
    @IBOutlet weak var lblhelpline: UILabel!
    
    @IBOutlet weak var lbladdress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Chnagelanguage()
        self.methodDropDownInquiries()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Chnagelanguage()
    {
        lblmaintitle.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        btnsend.setTitle("SEND".addLocalizableString(languageCode: languageCode), for: .normal)
        lblhelpline.text = "Toll Free 24/7 Helpline:".addLocalizableString(languageCode: languageCode)
        lbladdress.text = "ADDRESS".addLocalizableString(languageCode: languageCode)
        nameTextField.placeholder = "Name".addLocalizableString(languageCode: languageCode)
        
        
    }
    
    //MARK: - Send a message
    func sendMessage() {
        
        let messageVC = MFMessageComposeViewController()
        if let category = self.selectedCategory {
            messageVC.body = "\(String(describing: self.nameTextField.text!)) \n\(category) \n\n\(messageTextView.text!)"
        }
        messageVC.recipients = ["6969"]
        messageVC.messageComposeDelegate = self
        
        present(messageVC, animated: true, completion: nil)
    }
    
    // MARK: - Message Delegate method
    
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
    
    //MARK: - DropDown
    
    private func methodDropDownInquiries() {
        
        self.dropDownInquiries.placeholder = "Select Category"
        self.dropDownInquiries.options = ["Inquiry","Complaint","Suggestion","Feedback"]
        self.dropDownInquiries.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedCategory = option
        })
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionUANPressed(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "tel:080034778")! as URL)
    }
    
    @IBAction func action_fmfb(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
        webVC.fileURL = "https://www.hblmfb.com"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        //     print("\(String(describing: self.nameTextField.text!)) \n\(self.selectedCategory!) \n\n\(messageTextView.text!)")
        //        if (MFMessageComposeViewController.canSendText()) {
        //            print("SMS services are not available")
        //            self.sendMessage()
        //        }
        if (self.nameTextField.text?.isEmpty)!{
            self.showDefaultAlert(title: "", message: "Please enter name")
            return
        }
        if self.messageTextView.text.isEmpty{
            self.showDefaultAlert(title: "", message: "Please enter message")
            return
        }
        if self.selectedCategory == nil{
            self.showDefaultAlert(title: "", message: "Please select category")
            return
        }
        self.sendComplaint()
    }
    
    private func sendComplaint(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Complaint"
        
        let params = ["name":self.nameTextField.text!,"category":self.selectedCategory!,"message":self.messageTextView.text!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        if let message = self.genericObj?.message{
                            self.showDefaultAlert(title: "", message:message)
                        }
                    }
                    else {
                        if let message = self.genericObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.genericObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
            
        }
    }
}
