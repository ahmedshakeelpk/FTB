//
//  RateUsVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 15/05/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class RateUsVC: BaseVC {
    
    var rateVar : Int?
    var genericObj:GenericResponse?
    var transactionRef: Int?
    var transID : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transID = self.transactionRef
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action Methods
    
    @IBAction func sadFacePressed(_ sender: Any) {
        
        self.rateApp(cuResponse: 1)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func midFacePressed(_ sender: Any) {
        
        self.rateApp(cuResponse: 5)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func happyFacePressed(_ sender: Any) {
        
        self.rateApp(cuResponse: 10)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - API CALL
    
    private func rateApp(cuResponse:Int) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/Response"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"transaction_id":self.transID!,"customer_response":cuResponse] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                    
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                    }
                    else {
                        if let message = self.genericObj?.message{
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
