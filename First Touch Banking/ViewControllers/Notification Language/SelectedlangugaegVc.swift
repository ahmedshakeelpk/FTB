//
//  SelectedlangugaegVc.swift
//  First Touch Banking
//
//  Created by Irum Zubair on 26/12/2023.
//  Copyright © 2023 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import ObjectMapper

var language : String?
class SelectedlangugaegVc: BaseVC {
   
    var genericObj: GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.alpha = 0.6
        button1.setTitle("", for: .normal)
        radioButton1.setTitle("", for: .normal)
        radiobutton2.setTitle("", for: .normal)
        button2.setTitle("", for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var button1: UIButton!
    
    @IBAction func radioButton1(_ sender: UIButton) {
  
        self.NotificationsLanguage()
//        if let image = UIImage(named: "ic_checkbox") {
//            radioButton1.setBackgroundImage(image, for: .normal)
//                }
//
//
//        if let image2 = UIImage(named: "Unchecked") {
//            radiobutton2.setBackgroundImage(image2, for: .normal)
//                }
//
////        api calling
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.NotificationsLanguage()
//                }
    }
    
    @IBOutlet weak var radioButton1: UIButton!
    
    @IBAction func radiobutton2(_ sender: UIButton) {
//        radiobutton2.setBackgroundImage(UIImage(named: "ic_checkbox"), for: .normal)
//        radioButton1.setBackgroundImage(UIImage(named: "Unchecked"), for: .normal)
        //        api calling
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.NotificationsLanguageForUrdu()
//                }
      
        
    }
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var radiobutton2: UIButton!
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    private func NotificationsLanguageForUrdu(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Notifications/Language"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        
        //        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!, "notification_lang": language] as [String : Any]
        
        let params = ["notification_lang": "Urd"] as [String : Any]
        print(compelteUrl)
        print(header)
        print(params)
        NetworkManager.sharedInstance.enableCertificatePinning()
        //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: JSONEncoding.default, headers:header).response {
            response in
            //        Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<LeafInq>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                
                if response.response?.statusCode == 201 {
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        language = "Urdu"
                        
                        if let message = self.genericObj?.message {
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                        }
                        //                    if let message = self.CheckLeafObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
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
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    private func NotificationsLanguage(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Notifications/Language"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
     
//        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!, "notification_lang": language] as [String : Any]
  
        let params = ["notification_lang": "Eng"] as [String : Any]
        print(compelteUrl)
        print(header)
        print(params)
        NetworkManager.sharedInstance.enableCertificatePinning()
//        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: JSONEncoding.default, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<LeafInq>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                
                if response.response?.statusCode == 201 {
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        language = "English"
                        if let message = self.genericObj?.message {
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                        }
                        //                    if let message = self.CheckLeafObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
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
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
//https://mobappuat73.hblmfb.com/api/v1/Notifications/Language
    
}
