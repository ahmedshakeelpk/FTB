//
//  NotificationPopUpVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 19/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class NotificationPopUpVC: BaseVC {
    
    @IBOutlet weak var lblNotificationTitle: UILabel!
    var titleStr:String?
    var notificationPutObj : NotificationPut?
    var statusVar: Int?
    var likeVar : Int?
    var idVar : Int?

    var notifStatusVar : String?
    var notifLikeVar : String?
    var notifIdVar : String?
    static let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblNotificationTitle.text = "Alert details will appear here so that user can be prompted about the error".addLocalizableString(languageCode: languageCode)
        self.updateUI()

//        if let status = self.statusVar{
//            self.notifStatusVar = status
//        }
//        if let like = self.likeVar{
//            self.notifLikeVar = like
//        }
//        if let id = self.idVar{
//            self.notifIdVar = id
//        }
        print(statusVar)
        print(idVar)
        print(likeVar)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    //MARK: - Utility Methods
    
    private func updateUI() {
        self.lblNotificationTitle.text = titleStr
    }

    /*
     class CustomAlertVC: UIViewController {
     var completionBlock:CompletionBlock?
     
     @IBAction func okButtonPressed(_ sender: UIButton) {
     if self.completionBlock != nil {
     self.completionBlock!()
     }
     self.dismiss(animated: true, completion: nil)
     }
     
     }
    */
    
    //MARK: - Action Methods

    @IBAction func likePressed(_ sender: Any) {
        
        self.likeVar = 1
        self.getNotifications()
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func unLikePressed(_ sender: Any) {
        self.likeVar = -1
        self.getNotifications()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deletePressed(_ sender: Any) {
        
        self.statusVar = -1
        self.getNotifications()
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: - API CALL
    
    private func getNotifications() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        //        let id = Int(self.notifIdVar!)
        //        let status = Int(self.notifStatusVar!)
        //        let like = self.notifLikeVar
        if self.likeVar == nil{
            self.likeVar = 0
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Notifications"
        let params = ["id":self.idVar!,"status":self.statusVar!,"like":self.likeVar!]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<NotificationPut>) in
            //        Alamofire.request(compelteUrl, method: .put, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<NotificationPut>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.notificationPutObj = Mapper<NotificationPut>().map(JSONObject: json)
                    
                    if self.notificationPutObj?.response == 2 || self.notificationPutObj?.response == 1 {
                        if let message = self.self.notificationPutObj?.message{
                            self.showToast(title: message)
                        }
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
}
