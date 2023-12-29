//
//  DebitCardMainVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 26/03/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper
class DebitCardMainVc: BaseVC {
    var debitcardOBj: DebitCardModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblMain: UILabel!
    
    
    @IBOutlet weak var btnCardAct: UIButton!
    
    @IBOutlet weak var btnService: UIButton!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cardActivation(_ sender: UIButton) {
        DebitcardActivation()
    }
    
    
    
    @IBAction func services(_ sender: UIButton) {
        //        forGetServices()
    }
    
    
    
    private func DebitcardActivation()
    {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/DebitCard"
        let header: HTTPHeaders =
        ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        //        + " 00:00:01"
        //        + " 23:59:59"
        //        let parameters = ["from":convertDateFormater(Todatetextfield.text!) ,"to":convertDateFormater(fromdateTextField.text!)]
        //        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["lat": DataManager.instance.Latitude!, "lng": DataManager.instance.Longitude!, "imei": DataManager.instance.imei!] as [String : Any]
        //
        print(compelteUrl)
        //        print(parameters)
        print(params)
        print(DataManager.instance.stringHeader!)
        //
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response {
            response in
            //        Object { (response: DataResponse<DebitCardModel>) in
            
            ////
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<DebitCardModel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.debitcardOBj = Mapper<DebitCardModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
//                    self.debitcardOBj = response.result.value
                    if self.debitcardOBj?.response == 2 || self.debitcardOBj?.response == 1 {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardActivationVC") as! DebitCardActivationVC
                        let data = self.debitcardOBj?.datadebit?.accountDebitCard
                        vc.account_no = "\(data?.account_no)"
                        vc.status = data?.status
                        vc.card_expiry_month = data?.card_expiry_month
                        vc.card_expiry_year = data?.card_expiry_year
                        vc.card_id = data?.card_id
                        vc.card_type = data?.card_type
                        vc.debit_card_id = data?.debit_card_id
                        vc.debit_card_title = data?.debit_card_title
                        vc.pan = data?.pan
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        if let message = self.debitcardOBj?.message{
                            self.showAlert(title: "", message: message, completion: {
                                
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    else {
                        if let message = self.debitcardOBj?.message{
                            self.showDefaultAlert(title: "", message: message)
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
                else {
                    
                    if let message = self.debitcardOBj?.message{
                        self.showDefaultAlert(title: "", message: message)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
            
        }
        func forGetServices()
        {
            //        let data = self.debitcardOBj?.datadebit?.cardchannels
            //
            //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardActivationVC") as! DebitCardActivationVC
            //        self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
}
